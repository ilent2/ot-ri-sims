# Overview
This respository contains simulations using the
[Optical Tweezers Toolbox](https://github.com/ilent2/ott)
(version 1.5) that attempt to reproduce the results in the paper:

> Gregor Knoener, Simon Parkin, Timo A. Nieminen, Norman R. Heckenberg, Halina Rubinsztein-Dunlop
> "Measurement of refractive index of single microparticles"
> [Phys. Rev. Lett. 97, 157402](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.97.157402)

I am not the original author of this paper and these results 
should be verified before using them in anything signifcant.
This simulation is provided in the hope it will be useful for others.
If you find errors or think there might be a mistake, please do not
hesitate to open a pull request or post an issue on GitHub.

Why have I created this repository: I often get emails about code for
papers and how to reproduce it with the optical tweezers toolbox;
my supervisor often asks me for these kinds of plots; and I wanted
to test out [Papers With Code](https://paperswithcode.com/paper/measurement-of-refractive-index-of-single) to see if it would be useful for
linking papers with these sorts of code assets.

# Requirements

* Matlab (tested using R2022b)
* OTT (tested with rev. 623221c)

# Comments

Its hard to know the exact properties of the beam without
having an experimental measurement to compare with.
Its unclear exactly how the trapping efficiency is
estimated for Figure 1, here we assume its just the peak
force in the radial direction.
Its also unclear exactly how the trap stiffness is calculated/over which length scale.
Despite these uncertainties, the results agree well with
thouse presented in the paper.

Figure 1 is qualitatively interesting, but it is very difficult
to reproduce as its unclear exactly how the trapping efficiency
is calculated.
We get similar shapes that demonstrate the non-monoticity and
discontinuity, but its difficult to get the same scaling factor
(unless I'm missing something obvious).

Possible improvements could include doing dynamics simulations
to find the effective trap stiffness or corner frequency
instead of estimating the trap stiffness from the force profile.
This would probably produce results closer to reality.

