#Image cropping script. 
# Need way to prevent multiple croppings from occuring. I should set limit to crop size possibly
#Kevin Propst 10/13/2021

import argparse
import os
import sys
import cvlib
import cv2
import matplotlib.pyplot as plt
import numpy as np
from plantcv import plantcv as pcv
from plantcv.plantcv import params

def options():
    parser = argparse.ArgumentParser(description="Imaging processing with PlantCV.")
    parser.add_argument("-d", "--image", help="Input image file.", required=True)
    parser.add_argument("-r","--result", help="Result file.", required=False)    
    parser.add_argument("-o", "--outdir", help="Output directory for image files.", required=False)
    parser.add_argument("-w","--writeimg", help="Write out images.", default=False, action="store_true")
    parser.add_argument("-D", "--debug", help="Turn on debug, prints intermediate images.", action=None)
    args = parser.parse_args()
    return args

args = options()
pcv.params.outdir = args.outdir
pcv.params.debug = args.debug   


img = pcv.readimage(filename=args.image)

# This takes the file path and splits it so you can isolate the filename. Might not need it though
img_path = str(img)
print(img_path)

##example image
#img_path ='/Users/propst/Documents/image_analysis_project/hx_photo_examples/h3_nef/{Plot_29}{Experiment_H3}{Planted_03-05-2021}{SeedSource_SP18_20204}{SeedYear_18}{Genotype_B73}{Treatment_control}{PictureDay_13}.tiff'

split_path = img_path.split(',')
#print(split_path)
path = split_path[-1]
#print(path)
name = path.split(')')
name = name[0]
name = name.split('\'')
name = name[1]

print(name)

# #load in image look at dimensions. MUST BE TIFF FILE
# #img = plt.imread('/Users/propst/Documents/image_analysis_project/hx_photo_examples/h3_nef/{Plot_29}{Experiment_H3}{Planted_03-05-2021}{SeedSource_SP18_20204}{SeedYear_18}{Genotype_B73}{Treatment_control}{PictureDay_13}.tiff')

img = plt.imread(args.image)
                       
dimension = img.shape # num row, col, channels
size= img.size # height x width x channels
dtype = img.dtype #gives image type which in this case is unsigned character
# show = plt.imshow(img) # needs matplotlib.pyplot to work correctly.

print("Dimensions " + "= " + str(dimension))
print("Size"+" ="+" " +str(size))
print("dtype" + " = " + str(dtype))
# print(show)

# # new_size= input("Enter your new photo dimensions Starting_Row:End_Row, Starting_column:End_Column ")
# # cropped_img = img[new_size]
# Trying to think of way to input desired parameters still without having to alter code

##This will alter down each image so they are in this range 

cropped_img = img[80:3780, 150:5500] #Starting Row : End Row, Starting Column: End Column
crop = plt.imshow(cropped_img)

crop_dimension = cropped_img.shape # num row, col, channels
crop_size= cropped_img.size # height x width x channels
crop_dtype = cropped_img.dtype #gives image type which in this case is unsigned character
# show = plt.imshow(img) # needs matplotlib.pyplot to work correctly.

print("Dimensions " + "= " + str(crop_dimension))
print("Size"+" ="+" " +str(crop_size))
print("dtype" + " = " + str(crop_dtype))
print(crop) # New image

if crop_size >= size:
    print(name + ": This image does not need to be cropped!")
    quit()
else:
    next


# answer = input("Do you want to write new image to a directory? Y/N" +'\n')

# if answer == 'Y':
#     plt.savefig(name)
# else:
#     next
crop.axes.get_xaxis().set_visible(False)
crop.axes.get_yaxis().set_visible(False)

plt.savefig(name, dpi = 300 format = "tiff")
