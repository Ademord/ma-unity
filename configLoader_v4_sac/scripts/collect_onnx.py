import shutil
import os

'''
    For the given path, get the List of all files in the directory tree 
'''
def getListOfFiles(dirName):
    # create a list of file and sub directories 
    # names in the given directory 
    listOfFile = os.listdir(dirName)
    allFiles = list()
    # Iterate over all the entries
    for entry in listOfFile:
        # Create full path
        fullPath = os.path.join(dirName, entry)
        # If entry is a directory then get the list of files in this directory 
        if os.path.isdir(fullPath):
            allFiles = allFiles + getListOfFiles(fullPath)
        else:
            allFiles.append(fullPath)
                
    return allFiles

dirName = './results'

listOfFiles = getListOfFiles(dirName)

def adaptFileName(filename):
    s = filename.split('/')
    # print(s)
    return '{}.{}'.format(s[2], s[3]) 

for file in [x for x in listOfFiles if 'Drone.onnx' in x]:
    dst = 'onnx_files/{}'.format(adaptFileName(file))
    shutil.copyfile(file, dst)
