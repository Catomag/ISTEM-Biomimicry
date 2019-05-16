import os
import xml.etree.ElementTree as et
import matplotlib.pyplot as plt

currentPath = os.path.dirname(os.path.realpath(__file__))
xmlDirectory = os.path.join(currentPath, "Data//")

while True:
    fileIndex = 0
    for file in os.listdir(xmlDirectory):
        print("Working on file: " + file + " in file index: " + str(fileIndex))
        x = []
        y = [[], [], []]

        tree = et.parse(xmlDirectory+file)
        root = tree.getroot()

        generationNumb = 0

        for generation in root:
            x.append(generationNumb)

            childNumb = 0
            for child in generation:
                y[childNumb].append(int(float(child.text)))
                childNumb += 1

            generationNumb += 1

        plt.plot(x, y[0], color='b')

        plt.xlabel('Generation')
        plt.ylabel('Average fitness/Total fitness')

        plt.title('Average fitness by generation')

        plt.savefig("Graphs/data" + str(fileIndex) + ".png")

        plt.clf()
        fileIndex += 1
