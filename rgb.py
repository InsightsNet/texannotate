import colorsys
from collections import deque
import numpy as np

def generate_rainbow_colors():
    all_colors = np.empty((0,3), int)

    # Define steps for hue, saturation, and value
    h_step = 1/256
    s_step = 1/30
    v_step = 1/30
    for h in [i*h_step for i in range(256)]:
        for s in [i*s_step for i in range(30, 10, -1)]:
            for v in [i*v_step for i in range(30, 10, -1)]:
                r, g, b = [int(x * 255) for x in colorsys.hsv_to_rgb(h, s, v)]
                if not np.any(np.all(all_colors == [r, g, b], axis=1)):
                    all_colors = np.append(all_colors, np.array([[r, g, b]]), axis=0)


    segment = len(all_colors) // 8
    divided_colors = [deque(all_colors[i:i + segment]) for i in range(0, len(all_colors), segment)]

    # Convert numpy arrays inside the deques to tuples
    for color_deque in divided_colors:
        for i in range(len(color_deque)):
            color_deque[i] = tuple(color_deque[i])
    
    return divided_colors


def generate_rainbows(n, num):
    all_colors = generate_rainbow_colors()
    total_colors = sum(len(c) for c in all_colors)
    print(total_colors)

    if n * num > total_colors or (num // 8) > len(all_colors[0]):
        max_n_num = total_colors // num
        over = (n * num) - total_colors
        print(f"Current maximum of n*num is {max_n_num}. Your input exceeds by {over}. Please reduce the value of n or num.") 
        return

    split = [num // 8] * 8
    for i in range(num % 8):
        split[i] += 1

    rainbows = []
    for _ in range(n):
        rainbow = []
        for j in range(8):  # Ensure we're only iterating over 8 sections
            rainbow += [all_colors[j].popleft() for _ in range(min(split[j], len(all_colors[j])))]
        rainbows.append(rainbow)

    return rainbows



import matplotlib.pyplot as plt
import matplotlib.patches as patches
import math

def visualize_rainbows(rainbows, num_list):
    side = math.ceil(math.sqrt(max(len(r) for r in rainbows)))
    total_rainbows = min(num_list, len(rainbows))
    
    fig, ax = plt.subplots(figsize=(5, 5 * total_rainbows))
    ax.set_xlim(0, side)
    ax.set_ylim(0, side * total_rainbows)
    
    for idx in range(total_rainbows):
        current_rainbow = rainbows[idx]
        for i in range(side):
            for j in range(side):
                index = i * side + j
                if index < len(current_rainbow):
                    color = tuple(val/255 for val in current_rainbow[index])
                    rect = patches.Rectangle((j, side * (total_rainbows - idx - 1) + side - 1 - i), 1, 1, facecolor=color)
                    ax.add_patch(rect)

    ax.axis('off')
    plt.tight_layout()
    plt.show()


def check_duplicates(big_list):
    color_set = set(); duplicate_dic = {}
    for small_list in big_list:
        for color in small_list:
            if color not in color_set:
                color_set.add(color)
            else:
                if color in duplicate_dic:
                    duplicate_dic[color] += 1
                else:
                    duplicate_dic[color] = 1
    print(duplicate_dic)
    return duplicate_dic == {}




rainbows = generate_rainbows(100, 100) #65536, 256)
#for rainbow in rainbows:
    #print(rainbow)
visualize_rainbows(rainbows, 20)
print(check_duplicates(rainbows))  # Returns True if duplicates are found, else False
