# All of our import statements for the packages that we will use 
import numpy as np
import matplotlib.pyplot as plt
import argparse

# Define all of our arguments using the argparse package
parser = argparse.ArgumentParser()
parser.add_argument("--step-size", type=float, default=1.0)
parser.add_argument("--temp", type=int, default=300)
parser.add_argument("--outfile", type=str, default="test.png")
parser.add_argument("--start-index", type=int, required=False)
parser.add_argument("--end-index", type=int, required=False)
args = parser.parse_args()

# Get our data from the energy.dat file
data = np.genfromtxt('energy.dat',delimiter='')
energies = data[:,1].tolist()
steps = data[:,0].tolist()
steps = [int(i) for i in steps]

title = "Plot of Potential Energy over " + str((len(steps)*100)) + " Steps, Using Step Size Modified by a Factor of " + str(args.step_size) + " at Temperature of " + str(args.temp) + "K"  

# Apply index filters if they both exist
if (args.start_index is not None) and (args.end_index is not None):
    energies = energies[args.start_index:args.end_index]
    steps = steps[args.start_index:args.end_index]
    title = "Plot of Potential Energy over " + str((args.end_index - args.start_index)*100) + ", Using Step Size Modified by a Factor of " + str(args.step_size) + " at Temperature of " + str(args.temp) + "K"  

plt.plot(steps, energies)
plt.xlabel("Steps")
plt.ylabel("Potential Energy (J)")
plt.title(title, loc="center", wrap=True)
plt.savefig("Plots/"+args.outfile)

stepUp = 0
stepDown = 0
stay = 0

for i in range(1,len(energies)):
    if energies[i] == energies[i-1]:
        stay += 1
    elif energies[i] > energies[i-1]:
        stepUp += 1
    elif energies[i] < energies[i-1]:
        stepDown += 1

print("Total: " + str(stepUp + stepDown + stay))
print("Step Up: " + str(stepUp))
print("Stay: " + str(stay))
print("Step Down: " + str(stepDown))
print("Acceptance Rate: " + str(float(stepUp)/float(stepUp+stay)))
