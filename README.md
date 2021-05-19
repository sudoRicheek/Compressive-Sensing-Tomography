# Compressive-Sensing-Tomography

Here we explain the utility of Compressed Sensing in Tomographic reconstruction. We take 18 parallel beam projections from a MR volume of the brain and perform **filtered back-propagation using Ram-Lak filter** , **individual compressive reconstruction** and **2-3 slice cs recovery** for utilising the consecutive capture redundancies.

## How to reproduce the results ?

The code is present in **/Code**. Main code is present in `TomographyCS.m`. You will find the function handles used to mimic `radon(idct2())` and `iradon(dct2())` inside the `@radonDCT`, `@radonDCT2`, `@radonDCT3` folders.

```
execute TomographyCS.m to reconstruct the results.
```

## Results

### Original Slice

<p align="center">
  <img src="/Results/originalslice.jpg" width="400" />
</p>

### FBP Ram-Lak reconstruction with 18 projection angles

<p align="center">
  <img src="/Results/fbp.jpg" width="350" />
</p>

### CS based reconstructions(individual, 2-slice, 3-slice)

<p align="center">
  <img src="/Results/cs1slice1.jpg" width="350" />
</p>

<p align="center">
  <img src="/Results/cs2slice1.jpg" width="350" />
  <img src="/Results/cs2slice2.jpg" width="350" />
</p>

<p align="center">
  <img src="/Results/cs3slice1.jpg" width="250" />
  <img src="/Results/cs3slice2.jpg" width="250" />
  <img src="/Results/cs3slice3.jpg" width="250" />
</p>

## Forward Model Matrix for 2-slice and 3-slice reconstruction

<p align="center">
  <img src="/Results/fmm1.JPG" width="550" />
</p>
