import colorsys
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import math


def generate_rainbow_colors():  # number of color in one color
    all_colors = []
    all_colors_set = set()

    # Define steps for hue, saturation, and value
    hue_list = []
    for i in range(0, 359):
        hue_list.append(i/359)

    splited_hue_list = [hue_list[i::5] for i in range(5)]

    s_v_list = []
    for s in [i for i in range(256, 50, -1)]: 
        for v in [i for i in range(256, 50, -1)]:
            s_v_list.append([s/256, v/256])
    #print("num of s_v set: ", len(s_v_list))

    hue_list = []
    for s_v in s_v_list:
        for sub_hue_list in splited_hue_list:
            for hue in sub_hue_list:
                h = hue; s = s_v[0]; v = s_v[1]
                r, g, b = [int(x * 255) for x in colorsys.hsv_to_rgb(h, s, v)]
                #print((hue/10, s/100, v/100), "\t", (r, g, b))
                if (r, g, b) not in all_colors_set:
                    all_colors_set.add((r, g, b))
                    all_colors.append((r, g, b))
    #print("num of color: ", len(all_colors))
    return all_colors


def visualize_colors(colors):
    side = math.ceil(math.sqrt(len(colors)))
    
    fig, ax = plt.subplots(figsize=(side, side))
    ax.set_xlim(0, side)
    ax.set_ylim(0, side)
    
    for i in range(side):
        for j in range(side):
            index = i * side + j
            if index < len(colors):
                color = tuple(val/255 for val in colors[index])
                rect = patches.Rectangle((j, side - 1 - i), 1, 1, facecolor=color)
                ax.add_patch(rect)

    ax.axis('off')
    plt.tight_layout()
    plt.show()

colors = generate_rainbow_colors()[-50000:-1]
visualize_colors(colors)