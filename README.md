# iris_qa
Image Quality Assessment of iris images captured in the visible light spectrum based on someone else's paper

Main software
----
- `main.m` software is "main.m", which runs feature extraction on the data and writes the resulting data to `result.mat`
- `pokemon.m` is a SVM classifier for running a set of test and verification afterwards
- `dbRunTest.m` - For testing correct iteration of databases
- `imgDB.m` - Image dabatase list


Libraries
----
- `area.m` - Calculates the different areas to be used for assessment.  Number of pixels in the iris, signal/noise, and pupil
- `borderBoxx.m` - This calculates the min bounding box and angle of the pupil and iris
- `collective_focus_average.m` - Calculate the collective average of the image database focus, and store it in `focusList.mat`
- `focus.m` - Calculate the focus of an image with defined area to assess, The magnitude of the fourier spectrum
- `getDelta.m` - Calculates the delta values of coordinate
- `motion.m` - Calculates angle and magnitude of the motion blur
- `dftuv.m` - DFTUV Computes meshgrid frequency matrices - http://www.cs.uregina.ca/Links/class-info/425/Lab5/M-Functions/dftuv.m
- `hpfilter.m` - Computes frequency domain highpass filters - http://www.cs.uregina.ca/Links/class-info/425/Lab5/M-Functions/hpfilter.m
- `lpfilter.m` - Computes frequency domain lowpass filters - http://www.cs.uregina.ca/Links/class-info/425/Lab5/M-Functions/lpfilter.m
- `paddedsize.m` - Computes padded sizes useful for FFT-based filtering - http://www.cs.uregina.ca/Links/class-info/425/Lab5/M-Functions/paddedsize.m
- `pigment.m` - empty, a feature which was decided not to be implemented
- `rotateBox.m` - Returns area(M), width(W) and height(H) of a rotated box
