import sys
import os

input_dir = sys.argv[1]
output_file = sys.argv[2]

res_files = os.listdir(input_dir)

with open(output_file, 'w') as of:
	for r_f in res_files:
		if r_f.startswith("result"):
			with open(os.path.join(input_dir, r_f)) as inf:
				no_error = False
				phe_name = r_f.replace("result_", "")
				phe_name = phe_name.replace(".log", "")
				for line in inf:
					if line.startswith("Total Observed scale"):
						no_error = True
						line = line.strip()
						line = line.replace("Total Observed scale h2: ", '')
						parts = line.split()
						of.write(phe_name + "," + parts[0] + '\n')
				if not no_error:
					of.write(phe_name + ",NA\n")

