# Kalman Filter

## 1. Why Kalman Filter Exists?

### The Real-world problem

Imagine this:

You want to know where an aircraft is right now.

You have have:

- A mathematical model (physics)
- Sensors (GPS, accelerometer, radar)

But: 

- Models are never perfect
- Sensors are never exact

So the real question is : How do we combine an imperfect model and imperfect measurements to get the best possible estimate of the true state?

That is the Kalman Filter problem.

### What does "estimate" mean?

Suppose the true position is:

$$
    x_{true} = 100.0 \space m
$$

Your sensor says:

$$
    z = 102.3 \space m
$$

Is the true position 102.3 m?
Not necessarily - the sensor is noisy.

Your model predicts:

$$
    x_{model} = 98.7 \space m
$$ 

Which do you trust?
- Kalman Filter answers this quantitatively.

## 2. What is Noise?

### What is noise?

Noise is unwanted randomness added to a signal.

Examples:
- Electrical noise in circuits
- GPS position jitter
- Accelerometer vibration
- Wind gusts

Noise is:
- Random
- Unpredictable in exact value
- But predictable in statistics

### Why randomness must be modeled mathematically

You cannot predict: next noise value

But you can say:
- How large it usually is.
- How often large errors occur

This leads us to probability.

## 3. Probability

### What is probability?

Probability measures uncertainty,

If I say:
- "The error is small most of the time."
- "Large errors are rare."

I am describing a probability distribution.



