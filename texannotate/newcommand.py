from pylatexenc import macrospec
from pylatexenc.latexnodes.nodes import LatexGroupNode, LatexMacroNode, LatexCharsNode
from pylatexenc.latexwalker import LatexWalker, get_default_latex_context_db


class MySimpleNewcommandArgsParser(macrospec.MacroStandardArgsParser):
    def __init__(self):
        super(MySimpleNewcommandArgsParser, self).__init__(
            argspec='*{[[{',
            )

    def parse_args(self, w, pos, parsing_state=None, **kwargs):
        (argd, npos, nlen) = super(MySimpleNewcommandArgsParser, self).parse_args(
            w=w, pos=pos, parsing_state=parsing_state, **kwargs
        )
        if argd.argnlist[1].isNodeType(LatexGroupNode):
            argd.argnlist[1] = argd.argnlist[1].nodelist[0] # {\command} -> \command
        assert argd.argnlist[1].isNodeType(LatexMacroNode)
        argd.argnlist[1].nodeargd = None # hmmm, we should really have a
                                            # custom parser here to read a
                                            # single token
        newcmdname = argd.argnlist[1].macroname
        numargs = int(argd.argnlist[2].nodelist[0].chars) if argd.argnlist[2] else 0
        if argd.argnlist[2]:
            args = '['+'{'*numargs
        else:
            args = '{'*numargs

        new_latex_context = parsing_state.latex_context.filter_context()
        new_latex_context.add_context_category(
            'newcommand-{}'.format(newcmdname),
            macros=[
                macrospec.MacroSpec(newcmdname, args)
            ],
            prepend=True
        )
        new_parsing_state = parsing_state.sub_context(latex_context=new_latex_context)
        return (argd, npos, nlen, dict(new_parsing_state=new_parsing_state))


class MySimpleNewenvironmentArgsParser(macrospec.MacroStandardArgsParser):
    def __init__(self):
        super(MySimpleNewenvironmentArgsParser, self).__init__(
            argspec='*{[[{{',
            )

    def parse_args(self, w, pos, parsing_state=None, **kwargs):
        (argd, npos, nlen) = super(MySimpleNewenvironmentArgsParser, self).parse_args(
            w=w, pos=pos, parsing_state=parsing_state, **kwargs
        )
        if argd.argnlist[1].isNodeType(LatexGroupNode):
            argd.argnlist[1] = argd.argnlist[1].nodelist[0]
        assert argd.argnlist[1].isNodeType(LatexCharsNode)
        newcmdname = argd.argnlist[1].chars
        numargs = int(argd.argnlist[2].nodelist[0].chars) if argd.argnlist[2] else 0
        if argd.argnlist[2]:
            args = '['+'{'*numargs
        else:
            args = '{'*numargs

        new_latex_context = parsing_state.latex_context.filter_context()
        new_latex_context.add_context_category(
            'newenvironment-{}'.format(newcmdname),
            environments=[
                macrospec.EnvironmentSpec(newcmdname, args)
            ],
            prepend=True
        )
        new_parsing_state = parsing_state.sub_context(latex_context=new_latex_context)
        return (argd, npos, nlen, dict(new_parsing_state=new_parsing_state))



if __name__ == "__main__":
    latextext = r"""
\newenvironment{Abstract}{
\begin{center}\normalfont\bfseries Abstract\end{center}
\begin{quote}\par
}
{\end{quote}}

\begin{document}
\begin{Abstract}
    This abstract explain the approach userd to solve the problems at hand.
\end{Abstract}
Some text following the abstract. Some text following the abstract. Some text following the abstract.
\end{document}

\newcommand*{\c}[2][]{abc #1}
\newcommand\a{AAA}
\newcommand{\b}[2]{BBB #1}
\newcommand{\cright}{%
        \ifthenelse{\equal{\@arttype}{Supfile}}{%
		}{%
		\ifthenelse{\equal{\@status}{submit}}{%
		\fontdimen2\font=1.2pt
			\textbf{Copyright: }\copyright{} {\@ \the\year} by the \@authornum.\linebreak%
			Submitted to {\em\journalname} for %
			possible open access publication %
			under the terms and conditions of the Creative Commons Attri- bution %
			\ifthenelse{\equal{\@journal}{ijtpp}}{(CC BY-NC-ND)}{(CC BY)} %
			license %
			\ifthenelse{\equal{\@journal}{ijtpp}}{%
			\changeurlcolor{black}%
			(\href{https://creativecommons.org/licenses/by-nc-nd/4.0/}{https://creative}\linebreak\href{https://creativecommons.org/licenses/by-nc-nd/4.0/}{commons.org/licenses/by-nc-nd/4.0/).}%
			}{%
			\changeurlcolor{black}%
			(\href{https://creativecommons.org/licenses/by/4.0/}{https://}\linebreak\href{https://creativecommons.org/licenses/by/4.0/}{creativecommons.org/licenses/by/}\linebreak 4.0/).%
			}
			}{%
			\href{https://creativecommons.org/}{%
				\ifthenelse{\equal{\@journal}{ijtpp}}{%
					\includegraphics[width=2 cm]{Definitions/logo-ccby-nc-nd.eps}%
					}{%
					\includegraphics[width=2 cm]{Definitions/logo-ccby.eps}
					}
				}\\
				{\justifying\textbf{Copyright:} \copyright \ {\@copyrightyear} by the \@authornum.\linebreak%
				Licensee MDPI, Basel, Switzerland.\linebreak%
				This article is an open access article %
				distributed under the terms and \linebreak% 
				conditions of the Creative Commons Attribution %
				\ifthenelse{\equal{\@journal}{ijtpp}}{(CC BY-NC-ND)}{(CC BY)} %
				license %
				\ifthenelse{\equal{\@journal}{ijtpp}}{%
				\changeurlcolor{black}%
				\linebreak
				\href{https://creativecommons.org/licenses/by-nc-nd/4.0/}{(https://creativecommons.org/}\linebreak \href{https://creativecommons.org/licenses/by-nc-nd/4.0/}{licenses/by-nc-nd/4.0/}).%
				}{%
				\changeurlcolor{black}%
				(\href{https://creativecommons.org/licenses/by/4.0/}{https://} \href{https://creativecommons.org/licenses/by/4.0/}{creativecommons.org/licenses/by/}\linebreak 4.0/).}%
				}
			}
		}
	}

Blah blah blah.

Use macros: \a{} and \b{xxx}{yyy}.
    """.lstrip()

    latex_context = get_default_latex_context_db()
    latex_context.add_context_category('newcommand-category', prepend=True, macros=[
        macrospec.MacroSpec('newcommand', args_parser=MySimpleNewcommandArgsParser()),
        macrospec.MacroSpec('newenvironment', args_parser=MySimpleNewenvironmentArgsParser())
    ])

    lw = LatexWalker(latextext, latex_context=latex_context)

    parsing_state = lw.make_parsing_state()

    p=0
    nodes, npos, nlen = lw.get_latex_nodes(pos=p, parsing_state=parsing_state)

    parsing_state_defa = nodes[1].parsing_state
    parsing_state_defab = nodes[3].parsing_state

    parsing_state_defa_sqbr = nodes[2].nodeargd.argnlist[2].parsing_state

    pass