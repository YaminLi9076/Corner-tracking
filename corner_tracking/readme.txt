1. For corner tracking when camera and background are moving.
2. The algorithm is based on SIFT flow which is a combination of optical
flow and sift descriptor from Ce Liu.
3. The basic idea is we do the corner detection on the first frame of
the video and then keep tracking these pixels by SIFT flow.
4. The main file is the corner_tracking.m, the rest of the files are
from Ce Liu's work, original paper: SIFT Flow: Dense Correspondence
across Scenes and its Applications.
