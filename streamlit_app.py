import os
import shutil
import tarfile
import tempfile
import time
from pathlib import Path

import arxiv
import openai
import pandas as pd
import pdfplumber
import streamlit as st
from llama_index import (KeywordTableIndex, KnowledgeGraphIndex,
                         ServiceContext, SimpleDirectoryReader, SummaryIndex,
                         TreeIndex, VectorStoreIndex, download_loader,
                         set_global_service_context)
from llama_index.llms import OpenAI, Xinference
from llama_index.schema import Document
from PIL import Image
from st_files_connection import FilesConnection
from xinference.client import RESTfulClient

from pdfextract.export_annotation import export_annotation
from pdfextract.pdf_extract import pdf_extract
from texannotate.annotate_file import annotate_file
from texannotate.color_annotation import ColorAnnotation
from texcompile.client import compile_pdf_return_bytes
from utils.utils import (find_latex_file, postprocess_latex, preprocess_latex,
                         tup2str)

st.set_page_config(page_title='Chat with arXiv paper without PDF noise, powered by LaTeX Rainbow.', layout="wide")
texcompile_host = st.secrets.texcompile_host
texcompile_port = st.secrets.texcompile_port

def main():
    """
    The main function for the Streamlit app.

    :return: None.
    """
    st.title("Chat with arXiv paper, without PDF noise")
    st.sidebar.markdown('# Github link: [LaTeX Rainbow](https://github.com/InsightsNet/texannotate)')
    st.sidebar.markdown("""<small>It's always good practice to verify that a website is safe before giving it your API key. 
                        This site is open source, so you can check the code yourself, or run the streamlit app locally.</small>""", unsafe_allow_html=True)
    col1, col2 = st.columns([1, 0.8], gap='medium')
    with col2:
        with st.form("my_form"):
            api_key = st.text_input("Enter OpenAI API key here.", type='password')
            arxiv_id = st.text_input("Please enter a arXiv paper id:", value='1601.00978')
            submitted = st.form_submit_button("Submit and process arXiv paper (click once and wait)")
            if submitted:
                process_submit_button(col1, col2, arxiv_id, api_key)
                index = load_data()
                st.session_state["index"] = index
    if 'index' in st.session_state:
        if "imgs" in st.session_state.keys():
            with col1.container():
                for img in st.session_state["imgs"]:
                    st.image(img)

        chat_engine = st.session_state["index"].as_chat_engine(chat_mode="condense_question", verbose=True)

        if "messages" not in st.session_state.keys(): # Initialize the chat message history
            st.session_state.messages = [
                {"role": "assistant", "content": "Ask me a question about the paper!"}
            ]

        if prompt := st.chat_input("Your question"): # Prompt for user input and save to chat history
            st.session_state.messages.append({"role": "user", "content": prompt})
        
        for message in st.session_state.messages: # Display the prior chat messages
            with st.chat_message(message["role"]):
                st.write(message["content"])

        # If last message is not from assistant, generate a new response
        if st.session_state.messages[-1]["role"] != "assistant":
            with st.chat_message("assistant"):
                with st.spinner("Thinking..."):
                    response = chat_engine.chat(prompt)
                    st.write(response.response)
                    message = {"role": "assistant", "content": response.response}
                    st.session_state.messages.append(message) # Add response to message history


def process_submit_button(col1, col2, arxiv_id, api_key):
    with col2:
        with st.spinner("Downloading LaTeX code..."):
            filename = validate_input(arxiv_id)
            if not filename:
                st.error("id not found on arXiv, or the paper doesn't contain LaTeX code.")
                return

        with st.spinner("Annotating LaTeX code... please wait..."):
            df_toc, df_data = extract_file(filename, col1)
            df_data.to_csv('data.csv', sep='\t')

        with st.spinner("Loading llm..."):
            if api_key == '':
                st.error('Please set your OpenAI key.')
            if api_key == 'local':
                set_local_llm()
            else:
                openai.api_key = api_key
                set_openai_llm()

        st.info("Now you get a cleaned PDF. Only colored part are penned by paper author. Extracted text are resorted by the reading order.", icon="📃")


@st.cache_resource(show_spinner=True)
def load_data():
    df_data = pd.read_csv('data.csv', sep='\t')
    text = ''
    section_id = 0
    df_data.index.name='myindex'
    for i, row in df_data[df_data['reading_order']!=-1].sort_values(by=['reading_order', 'myindex']).iterrows():
        if row['section_id'] > section_id:
            text += '\n'
            section_id = row['section_id']
        if row['label'] != 'Figure':
            text += row['token'] + ' '
    sections =  text.split('\n')
    docs = [Document(text=section) for section in sections]
    with st.spinner(text="Loading and indexing the paper - hang tight! This should take 1-2 minutes."):
        index = VectorStoreIndex.from_documents(docs)
        return index
    

def validate_input(arxiv_id):
    try:
        paper = next(arxiv.Search(id_list=[arxiv_id]).results())
        filename = paper.download_source()
        return filename    
    except:
        return False

def extract_file(filename, col1):
    with col1:
        placeholder = st.empty()
        st.session_state['imgs'] = []
        try:
            Path("tmp").mkdir(parents=True, exist_ok=True)
            td = 'tmp'
            #print('temp dir', td)
            with tarfile.open(filename ,'r:gz') as tar:
                tar.extractall(td)
                preprocess_latex(td)

            basename, pdf_bytes = compile_pdf_return_bytes(
                sources_dir=td,
                host=texcompile_host, 
                port=texcompile_port
            ) # compile the unmodified latex firstly
            with placeholder.container():
                for page in pdfplumber.open(pdf_bytes).pages:
                    image = page.to_image(resolution=300).original
                    st.image(image)

            shapes, tokens = pdf_extract(pdf_bytes)
            ## get colors
            color_dict = ColorAnnotation()
            for rect in shapes:
                color_dict.add_existing_color(tup2str(rect['stroking_color']))
            for token in tokens:
                color_dict.add_existing_color(token['color'])
            shutil.rmtree(td)
            Path("tmp").mkdir(parents=True, exist_ok=True)

            with tarfile.open(filename ,'r:gz') as tar:
                tar.extractall(td)
            tex_file = Path(find_latex_file(Path(basename).stem, basepath=td)).name
            annotate_file(tex_file, color_dict, latex_context=None, basepath=td)
            postprocess_latex(str(Path(find_latex_file(Path(basename).stem, basepath=td))))
            basename, pdf_bytes_mod = compile_pdf_return_bytes(
                sources_dir=td,
                host=texcompile_host, 
                port=texcompile_port
            ) # compile the modified latex
            placeholder.empty()
            with placeholder.container():
                for page in pdfplumber.open(pdf_bytes_mod).pages:
                    image = page.to_image(resolution=300).original
                    st.image(image)
            shapes, tokens = pdf_extract(pdf_bytes_mod)
            df_toc, df_data = export_annotation(shapes, tokens, color_dict)
            shutil.rmtree(td)

            colors = {
                "Abstract":(255, 182, 193), "Author":(0, 0, 139), "Caption":(57, 230, 10),
                "Equation":(255, 0, 0),"Figure":(230, 51, 249),"Footer":(255, 255, 255),
                "List":(46, 33, 109),"Paragraph":(181, 196, 220),"Reference":(81, 142, 32),
                "Section":(24, 14, 248),"Table":(129, 252, 254),"Title":(97, 189, 251)
            }
            imgs = []
            placeholder.empty()
            with placeholder.container():
                for i, page in enumerate(pdfplumber.open(pdf_bytes).pages):
                    image = page.to_image(resolution=300)
                    for _, rect in df_data.iterrows():
                        if rect['page'] == i+1:
                            color = colors.get(rect['label'], (0,0,0))
                            image.draw_rect((rect['x0'], rect['y0'], rect['x1'], rect['y1']), fill=(color[0],color[1],color[2],70), stroke=color, stroke_width=1)
                    imgs.append(image.annotated)
                    st.image(image.annotated)
            st.session_state['imgs'] = imgs
            return df_toc, df_data

        except Exception as e:
            raise e
            #st.error("LaTeX code parsing error, please follow LaTeX Rainbow's example to add new parsing rules.")
            return None, None

def set_local_llm():
    port = 9997  # replace with your endpoint port number
    client = RESTfulClient(f"http://localhost:{port}")

    # Download and Launch a model, this may take a while the first time
    model_uid = client.launch_model(
        model_name="llama-2-chat",
        model_size_in_billions=7,
        model_format="pytorch",
        quantization="none",
    )

    # Initiate Xinference object to use the LLM
    llm = Xinference(
        endpoint=f"http://localhost:{port}",
        model_uid=model_uid,
        temperature=0.5,
        max_tokens=512,
    )
    service_context = ServiceContext.from_defaults(
        llm=llm, embed_model="local:BAAI/bge-small-en"
    )
    set_global_service_context(service_context)


def set_openai_llm():
    service_context = ServiceContext.from_defaults(llm=OpenAI(model="gpt-3.5-turbo", temperature=0.5, system_prompt="You are an expert on the paper and your job is to answer technical questions. Keep your answers precise and based on facts – do not hallucinate features."))
    set_global_service_context(service_context)


if __name__ == '__main__':
    main()