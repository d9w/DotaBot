# DotaBot

A submission in the 2020 GECCO Dota 2 [Competition](https://web.cs.dal.ca/~dota2/?page_id=353)

We used [CGP](https://github.com/d9w/CartesianGeneticProgramming.jl) and
[NEAT](https://github.com/d9w/NEAT.jl) to evolve agents for Dota 2 1v1 laning.
Our evolutionary code is
[here](https://github.com/luhervier/Project-Breezy-DOTA-Evolutionnary) and an
article explaining our approach is [here](article.pdf).

## Installation

The requirements for this bot are the [Project
Breezy](https://web.cs.dal.ca/~dota2/?page_id=353) requirements and the [Julia](https://julialang.org/) language. From the Julia package manager, first install the NEAT and CGP dependendies:

```julia
pkg> add https://github.com/d9w/NEAT.jl
pkg> add https://github.com/d9w/CartesianGeneticProgramming.jl
```

then the DotaBot can be installed. The recommended method is to clone the
repository to a specific directory, where scripts can be launched, and then use
Julia to add the local repository.

```bash
$ git clone https://github.com/d9w/DotaBot.jl
$ cd DotaBot.jl
$ julia
pkg> develop .
```

These instructions are written in Linux format but work equally in Windows. For
Windows Julia installations, the [Juno](https://junolab.org/) add-on for Atom is
recommended, which easily enables editing and calling Julia scripts.

## Agents

This repository comes with the genes of multiple best individuals from
evolution. The submission individual is `models/best_cgp.dna` and can be run
using the `cgp_agent.jl` script:

```bash
$ julia agents/cgp_agent.jl
```

Other individual files can be provided with

```bash
$ julia agents/cgp_agent.jl --ind models/cgp2.dna
```
