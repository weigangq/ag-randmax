# Cono-models

QiuLab research (Spring 2023)
* Applications of random matrix theory (RMT) to antigen diversifiation
* ML protein classifiers

Group: Qiu Lab (Hunter College of CUNY)
Semeter: Spring, 2023

## A reading list
### Molecular diversity of conosnail toxins (Holford lab)
- Gorson et al (2015). https://academic.oup.com/gbe/article/7/6/1761/2466146
### Protein toxin predictions
- Mansbach et al (2019). Snails In Silico: A Review of Computational Studies on the Conopeptides. Marine Drugs.https://www.mdpi.com/1660-3397/17/3/145
- Zhang et al (2016). "Using the SMOTE technique and hybrid features to predict the types of ion channel-targeted conotoxins". https://www.sciencedirect.com/science/article/abs/pii/S0022519316300686?via%3Dihub
- Shi et al (2022). ToxMVA: An end-to-end multi-view deep autoencoder method for protein toxicity prediction. https://www.sciencedirect.com/science/article/abs/pii/S0010482522010307?via%3Dihub
- SMOTE for balancing Data: https://machinelearningmastery.com/smote-oversampling-for-imbalanced-classification/
- Sampling to correct for imbalanced data sets: https://imbalanced-learn.org/stable/index.html 

### Applications of random matrix in biological network characterization
- Kikkawa, A. Random Matrix Analysis for Gene Interaction Networks in Cancer Cells. Sci Rep 8, 10607 (2018). https://doi.org/10.1038/s41598-018-28954-1
This paper uses spacings of adjacent eigenvalues (Ps) to characterize cancer gene networks. 
-- P(s) is found to follow Wigner distribution (eigenvalues are correlated and repel each other) when network is dense (many edges).
-- P(s) is Poisson distributed when gene network is sparse (small number of edges, eigenvalues are independent)

### General-purpose protein classifers (with protein language models)
- Multiple Sequence Alignment (MSA) generative protein language models: Lupo et al (2022)."Protein language models trained on multiple sequence alignments learn phylogenetic relationships". Nature Communications. https://www.nature.com/articles/s41467-022-34032-y
- Strodthoff N, Wagner P, Wenzel M, Samek W. (2020). UDSMProt: universal deep sequence models for protein classification. Bioinformatics. 2020 Apr 15;36(8):2401-2409. https://doi/10.1093/bioinformatics/btaa003. Github: https://github.com/nstrodt/UDSMProt
- Ananthan Nambiar, Simon Liu, Maeve Heflin, John Malcolm Forsyth, Sergei Maslov, Mark Hopkins and Anna Ritz (2023). Transformer Neural Networks for Protein Family and Interaction Prediction Tasks. J. Computational Biology. 30 (1): 95. DOI: 10.1089/cmb.2022.0132. Github: https://github.com/annambiar/PRoBERTa
- ESM-1b model: https://github.com/facebookresearch/esm
- TAPE Transformer model: https://www.sciencedirect.com/science/article/pii/S2405471222000382

### An example of using language model for predicting sequence evolution
- Hie, Yang, and Kim (2023). Evolutionary velocity with protein language models pedicts evolutionary dynamics of diverse proteins. https://www.sciencedirect.com/science/article/pii/S2405471222000382

### ICTCPred Random Forest model using SMOTE sampling
https://www.sciencedirect.com/science/article/pii/S0022519316300686

## Data & tools
- Conoserver: https://www.conoserver.org/
- AlphaFold: https://github.com/deepmind/alphafold
- Conodictor: https://github.com/koualab/conodictor


