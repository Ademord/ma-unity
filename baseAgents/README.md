## how to install
1. `sudo apt install python3-pip && pip install mlagents torch tensorflow cattrs==1.0.0`
2. `echo "export PATH=\"`python3 -m site --user-base`/bin:\$PATH\"" >> ~/.bashrc`
3. `./train_visON.sh run65 5000 &`

## v2 
- fixes Object detector error =0 >> NOT FIXED!!!
- fixes config loading in play-mode without config
- fixes obs space
- adds obs for inside or outside of allowed space `m_OutsideAllowed`
- fixed look error
- fixed moving forward
