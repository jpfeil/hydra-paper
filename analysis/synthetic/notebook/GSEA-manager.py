#!/usr/bin/env python3.8

import subprocess
import sys
import os
import glob
import shutil
import shlex
import errno
import time

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise

# Changed Rscript /usr/bin/Rscript
_ssgsea = """
Rscript bin/pan-hallmark-ssGSEA.R
{input}
{output}
{gmt}
"""

_gsva = """
Rscript bin/pan-hallmark-GSVA.R
{input}
{output}
{gmt}
"""
_plage = """
Rscript bin/pan-hallmark-PLAGE.R
{input}
{output}
{gmt}
"""

target = os.path.join(sys.argv[1])
base = os.path.basename(target)
fields = base.split('-')
hallmark = fields[1]
tag = '-'.join(fields[3:-3])

# ssGSEA
output_dir = os.path.join(sys.argv[2], 'ssGSEA', tag)
mkdir_p(output_dir)
output_pth = os.path.join(output_dir, hallmark)
cmd = _ssgsea.format(input=target,
                     output=output_pth, 
                     gmt=sys.argv[3])

cmd = shlex.split(cmd)

tic = time.perf_counter()
subprocess.check_call(cmd)
toc = time.perf_counter()

time_pth = output_pth + '_TIME'
with open(time_pth, 'w') as f:
    f.write(str(toc - tic))

# GSVA
output_dir = os.path.join(sys.argv[2], 'GSVA', tag)
mkdir_p(output_dir)
output_pth = os.path.join(output_dir, hallmark)
cmd = _gsva.format(input=target,
                   output=output_pth,
                   gmt=sys.argv[3])

cmd = shlex.split(cmd)

tic = time.perf_counter()
subprocess.check_call(cmd)
toc = time.perf_counter()

time_pth = output_pth + '_TIME'
with open(time_pth, 'w') as f:
    f.write(str(toc - tic))

# PLAGE
#output_dir = os.path.join(sys.argv[2], 'PLAGE', tag)
#mkdir_p(output_dir)
#output_pth = os.path.join(output_dir, hallmark)
#cmd = _plage.format(input=target,
#                    output=output_pth,
#                    gmt=sys.argv[3])
#
#cmd = shlex.split(cmd)
#subprocess.check_call(cmd)
