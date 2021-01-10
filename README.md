# GBF-SEG-GSP and GBF-SEG-NNK
## Graph based fusion for change detection using graph-cut segmentation and signal representation approaches (signal smoothness and spectral filtering) for graph learning.
This repository contains graph learning models based on signal representation, namely signal smoothness and spectral filtering, for the graph learning stage of GBF-CD model [1], a change detection algorithm. In addition to modifying the graph learning stage, in this new model, we use graph cut segmentation instead of Nyström extension in order to reduce computational complexity. We carry out tests on 14 real cases datasets of Multispectral images including some multimodal acquisitions of natural disasters. Our proposal got to improve the GBF-CD model performance in 9 out of 14 datasets.

Here you will find all the code used to generate a change map in fourteen cases of study including fires, floods, melt ice, buildings, and a earthquake.

``` GBF-SEG-GSP_NNK.m ``` is the main code that generates the change maps.
``` cohensKappa.m ``` will generate all the results showed in the paper and also the change map with respect to False Alarms (**FA**), Missed Alarms (**MA**), Precision (**P**), Recall (**R**), Cohen's Kappa (**K**), and Overral Error (**OE**).


**Note:** The metrics shown in the thesis document were obtained using Matlab 2018a and these vary depending on the Matlab version. In case of having a different version, please execute the grid search decommenting the corresponding lines in ``` GBF-SEG-GSP_NNK.m ```

## REFERENCES

[1] D. A. Jimenez-Sierra, H. D. Benítez-Restrepo, H. D. Vargas-Cardona, and J. Chanussot,“Graph-based data fusion applied to: Change detection and biomass estimation in rice crops,”Remote Sensing, vol. 12, p. 2683, Aug 2020.
