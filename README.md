# A Preliminary Study of Osteoarthritis Evaluation Using Microwave-induced Thermoacoustic Imaging with Bone Artifact Suppression

This repository contains the MATLAB code used for Microwave‑induced Thermoacoustic Imaging (MITAI) reconstruction and bone‑artifact suppression in our osteoarthritis evaluation study. The implementation includes the Delay‑and‑Sum (DAS) algorithm for initial image formation and the proposed bone artifact suppression algorithm for post‑processing artifact mitigation. The code is designed to process raw thermoacoustic data acquired from simulation, tissue‑mimicking phantom, and human in‑vivo finger‑joint experiments.

**Data & Workflow:**
- **Datasets:** Sample raw thermoacoustic data are provided for human finger‑joint cases. Reconstruction: Reconstruct initial MITAI image by running DAS.m in MATLAB.
- **Reconstruction:** Reconstruct initial MITAI image by running DAS.m in MATLAB.
- **Enhancement:** Run BoneArtifactSuppression.m, load the DAS reconstruction result to perform bone‑reflection artifact suppression.

- This work is associated with the paper **"A Preliminary Study of Osteoarthritis Evaluation Using Microwave‑induced Thermoacoustic Imaging with Bone Artifact Suppression"** conducted at the **Chongqing University of Posts and Telecommunications (CQUPT)**.

THIS CODE IS PROVIDED FOR ACADEMIC RESEARCH PURPOSES ONLY, ON AN "AS IS" BASIS. THE AUTHOR MAKES NO REPRESENTATIONS OR WARRANTIES OF ANY KIND CONCERNING ITS COMPLETENESS, ACCURACY, OR FITNESS FOR A PARTICULAR PURPOSE. USERS ASSUME ALL RISKS ASSOCIATED WITH ITS USE. THE AUTHOR SHALL NOT BE LIABLE FOR ANY LOSS OR DAMAGE ARISING FROM THE USE OF THIS CODE.IF YOU ARE PUBLISHING ANY WORK WHERE THIS CODE OR A VARIANT OF IT HAS BEEN USED, PLEASE REMEMBER THAT IT WAS OBTAINED FREE OF CHARGE. WE KINDLY ASK THAT YOU REFERENCE OUR PAPER IN THE PUBLICATION. 
