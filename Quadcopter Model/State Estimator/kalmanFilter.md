# Kalman Filter

## The Basics

### Why do we need a filter?

Imagine you're trying to track a friend's location in a foggy park using only glimpses of their flashlight. The fog blurs your view (noise), and you only see flashes occasionally (measurements). Your brain predicts where they'll be next based on their walking pattern (model), then corrects when you see a flash. The Kalman Filter does exactly this mathematically for computers: it estimates "hidden truths" (like position) from imperfect, noisy data.

**Key Idea: Real-world data is always noisy-sensors glitch, models aren't perfect. KF "filters" out the junk to give the best possible guess.**

### What is noise?

- Noise is any unwanted random variation in data. Like static on radio: it muddles the signal (true) you care about.
    - **Signal**: The true underlying pattern (e.g., a car's exact speed).
    - **Noise**: Random errors (e.g., wind jiggling the speedometer).
- Without filtering, noise makes estimates jumpy and useless. KF smooths it intelligently.

### What is White Noise? (The "Random Buzz" KF Assumes)

- White noise is a specific type of noise: **random, uncorrelated, and zero-mean** (averages to zero over time).

    - Why "white"? Like white light (all frequencies equal), it has equal power across all times/frequencies-no patterns, just flat randomness.

    - **Key Properties**
            - Zero mean: $\mathbb{E}[w] = 0$
            - Uncorrelated: Future noise doesn't depend on past noise. If $w_k$ is noise at time $k$, then $\mathbb{E}[w_kw_{k-1}] = 0$ (no memory)
            - Stationary: Same statistics (variance) at all times.

- **Symbol** : We donte white noise as $w_k$ or $v_k$ (process or measurement noise).

- **Gaussian White Noise**: KF assumes noise is Gaussian (bell-shaped). Why? Math works out nicely (more below).

## Probability Basics - The Language of Uncertainty

KF is built on probability: It doesn't give a single "answer" but a distribution (range of possibilities) witha a "best guess" and uncertainty.

### The Normal (Gaussian) Distribution and $\mathcal{N}$

![Normal Distribution](normal_distribution.png)

- **What is it?** The famous bell curve - most common distribution in nature (heights, errors, etc.) due to Central Limit Theorem (many small random effects add up to bell-shaped).

    - Symmetric, single peak, tail fades to zero
    - 68% of values within $1\sigma$ of mean and 95% within $2\sigma$

- **Symbol**: $x \sim \mathcal{N}(\mu,\sigma^2)$

    - $x \sim:$ "x follows" or "x is distributed as"
    - $\mathcal{N}:$ Script "N" for Normal (Gaussian)
    - $(\mu, \sigma^2):$ Parameters - mean and variance 
    - **Vector Form**: $\mathbf{x} \sim \mathcal{N}(\boldsymbol{\mu}, \boldsymbol{\Sigma})$, where $\boldsymbol{\Sigma}$ is the covariance matrix (diagonal if independent dimensions).

- **Why Gaussian for KF?**

    - Linearity + Gaussian noise, the posterior stays Gaussian (conjugate property: easy math)
    - Real noise is often approximately Gaussian.

### Bayesian Updating (The Heart of KF)

- **Bayes' Rule:**Update beliefs with new data.

$$
    \text{Posterior} \propto \text{Likelihood} \times \text{Prior}
$$

    Prior: Your belief before the new data (from model/past).
    Likelihood: How well data fits the belief (new evidence).
    Posterior: Updated belief after data

- KF applies this recursively: Prior→(Predict)→Likelihood (measurement) → Posterior → Repeat

## The State-Space Model - What KF Estimates

KF models dynamic systems as hidden states evolving over time, observed noisily.

### Core Components

- **Time Steps**: Discrete $k=1,2,\dots$
- **State $\mathbf{x}_k$**: Hidden vector of what you care about. (e.g., $[position,velocity]^T$). Size: $n \times 1$
    - Why hidden? You can't measure it directly (e.g., true velocity isn't sensed)
- **Measurement mathbf{x}_k**