imptest = importdata('segmentation.test',',');
impdata = importdata('segmentation.data',',');






kNN = 20;

kNNThis(1,imptest,impdata);
kNNThis(10,imptest,impdata);
kNNThis(20,imptest,impdata);