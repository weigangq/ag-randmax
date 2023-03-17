# ag-randmax

QiuLab research (Spring 2023)
* Applications of random matrix theory (RMT) to antigen diversifiation
* ML protein classifiers

Group: Qiu Lab (Hunter College of CUNY)
Semeter: Spring, 2023

## A reading list
### Applications of random matrix in biological network characterization
- Mansbach et al (2019). Snails In Silico: A Review of Computational Studies on the Conopeptides. Marine Drugs.https://www.mdpi.com/1660-3397/17/3/145
- Kikkawa, A. Random Matrix Analysis for Gene Interaction Networks in Cancer Cells. Sci Rep 8, 10607 (2018). https://doi.org/10.1038/s41598-018-28954-1
This paper uses spacings of adjacent eigenvalues (Ps) to characterize cancer gene networks. 
-- P(s) is found to follow Wigner distribution (eigenvalues are correlated and repel each other) when network is dense (many edges).
-- P(s) is Poisson distributed when gene network is sparse (small number of edges, eigenvalues are independent)

### General-purpose protein classifers (with protein language models)
- Strodthoff N, Wagner P, Wenzel M, Samek W. (2020). UDSMProt: universal deep sequence models for protein classification. Bioinformatics. 2020 Apr 15;36(8):2401-2409. https://doi/10.1093/bioinformatics/btaa003. Github: https://github.com/nstrodt/UDSMProt
- Ananthan Nambiar, Simon Liu, Maeve Heflin, John Malcolm Forsyth, Sergei Maslov, Mark Hopkins and Anna Ritz (2023). Transformer Neural Networks for Protein Family and Interaction Prediction Tasks. J. Computational Biology. 30 (1): 95. DOI: 10.1089/cmb.2022.0132. Github: https://github.com/annambiar/PRoBERTa
- ESM-1b model: https://github.com/facebookresearch/esm
- TAPE Transformer model: https://www.sciencedirect.com/science/article/pii/S2405471222000382

### An example of using language model for predicting sequence evolution
- Hie, Yang, and Kim (2023). Evolutionary velocity with protein language models pedicts evolutionary dynamics of diverse proteins. https://www.sciencedirect.com/science/article/pii/S2405471222000382

## Data sets
- Conoserver: https://www.conoserver.org/


