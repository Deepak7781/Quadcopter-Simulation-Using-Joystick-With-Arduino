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

- **Bayes' Rule:** Update beliefs with new data.

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

- **State $\mathbf{x}_k$** : Hidden vector of what you care about. (e.g., $[position,velocity]^T$). Size: $n \times 1$
    - Why hidden? You can't measure it directly (e.g., true velocity isn't sensed)

- **Measurement $\mathbf{x}_k$** : What you observe (e.g., GPS position). Size : $p \times 1$, $p \leq n$.

- **Measurement $\mathbf{u}_k$** : Known inputs (e.g., acceleration pedal). Optional.

### The Two Equations (Linear Gaussian Model)

1. **Process (Dynamics) Equation:** How state evolves.

$$
    \mathbf{x}_k = \bold{A}\mathbf{x}_{k-1} + \bold{B}\mathbf{u}_{k-1} + \mathbf{w}_{k-1}
$$

- $\bold{A}:$ Transition matrix (how state maps forward, e.g., $ \begin{bmatrix} 1 & \Delta t \\\\ 0 & 1  \end{bmatrix}$ for constant velocity: pos += vel*time).

- $\bold{B}:$ Control matrix (how inputs affect state).

- $\mathbf{w}_{k-1} \sim \mathcal{N}(0,\bold{Q}):$ Process white noise - models uncertainty in dynamics (e.g., wind, unmodeled friction). $\bold{Q}$ : Covariance (how much "wiggle room").

2. **Measurement Equation:** How state produces observation.

$$
    \mathbf{z}_k = \bold{H}\mathbf{x}_{k} + \mathbf{v}_{k}
$$

- $\bold{H}$ : Observation Matrix (what parts of state you measure, e.g., [1, 0] for position only).

-  $\mathbf{w}_{k-1} \sim \mathcal{N}(0,\bold{R}):$ Measurement white noise (sensor error). $\bold{R}$ : Covariance (sensor precision).

### Assumptions

- Linearity (A, H fixed or time-varying but linear)
- Gaussian white noise (uncorrelated, zero-mean)
- Markov: Future depends only on present (memoryless dynamics)

### Goal of KF: 
Compute **posterior** $p(\mathbf{x}_k|\mathbf{Z}_k) \approx \mathcal{N}(\hat{\mathbf{x}}_{k|k}, \bold{P}_{k|k})$, where $\mathbf{Z}_k = {z_1,z_2,\dots, z_k}$


## How the Kalman Filter Works - The Predict-Correct Cycle

KF is **recursive**: Uses previous posterior to predict, then correxts with new data. Two steps per time $k$

### Notation Refresher

- $\hat{\mathbf{x}}_{k|k-1}$ : Prior mean (predict for k using data to k-1).

- $\bold{P}_{k|k-1}$ : Prior covariance

- $\hat{\mathbf{x}}_{k|k}$ : Posterior mean

-  $\bold{P}_{k|k}$ : Posterior covariance

### Step 1: Predict (Time Update) - Propagate Belief Forward

From posterior $k-1$ , forecast to $k$ using dynamics.

$$
\hat{\mathbf{x}}_{k|k-1} = \bold{A}\hat{\mathbf{x}}_{k-1|k-1} + \bold{B}\mathbf{u}_{k-1}
$$

- **Why?** : Linear expectation: $\mathbb{E}[\mathbf{x}_k] = \bold{A}\mathbb{E}[\mathbf{x}_{k-1}] + \bold{B}\mathbf{u}$ (noise mean = 0)

$$
    \bold{P}_{k|k-1} = \bold{A}\bold{P}_{k-1|k-1}\bold{A}^T + \bold{Q}
$$

- **Why?** : Variance propagates: $ Var(\bold{A}\mathbf{x}) = \mathbf{A}Var(\mathbf{x})\bold{A}^T$ , plus added noise Q. (Transpose for matrix math.)

### Step 2: Correct (Measurement Update) - Fuse with New Data

Incorporate $\mathbf{z}_k$ via Bayes.

- **Innovation (Residual)** : $\mathbf{y}_k = \mathbf{z}_k - \bold{H}\hat{\mathbf{x}}_{k|k-1}$
    - Predicted measurement minus actual: How off was the prior.

- **Innovation Covariance** : Uncertainty in residual. $\bold{S}_k = \bold{H}\bold{P}_{k|k-1}\bold{H}^T + \bold{R}$
    - Predicted uncertainty projected to measurement space + sensor noise.

- **Kalman Gain $K_k$** : How much to trust measurement vs. prior.

$$
    \bold{K}_k = \bold{P}_{k|k-1}\bold{H}^T S_{k}^{-1}
$$

- **Posterior Mean** :

$$
    \hat{\mathbf{x}}_{k|k} = \hat{\mathbf{x}}_{k|k-1} + \bold{K}_k\mathbf{y}_{k}
$$

- **Posterior Covariance** :

$$
    \bold{P}_{k|k} = (\bold{I} - \bold{K}_k\bold{H})\bold{P}_{k|k-1}
$$

$\bold{I}$ : Identity matrix