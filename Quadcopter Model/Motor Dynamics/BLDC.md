# Brushless Direct Current (BLDC) Motor

## Introduction

- Brushless DC (BLDC) motors, also known as Electronically Commutated Motors, are a type of Permanent Magnet Synchronous Motor (PMSM) that operates on direct current (DC) power but uses electronic commutation instaed of mechanical brushes.

- Unlike traditional brushed DC motors, BLDC motors eliminate the need for physical brushes and commutators, which reduces wear, improves efficiency, and enhances reliability.

- They are widely used in applications requiring high efficiency, precise speed control, and long life, such as electric vehicles, drones, computer fans, and industrial automation.

- BLDC motors convert electrical energy into mechanical energy through electromagnetic interactions between stator windings and rotor magnets. The "brushless" aspect refers to the absence of brushes, while "DC" indicates the input power source (though the internal operation mimics AC due to electronic switching)

## Working Principle

The core principle of a BLDC motor relies on the interaction between a permanent magnet rotor and a stator with electromagnets (windings). The rotor typically consists of permanent magnets arranged in poles (e.g., 2, 4, 6 or more), creating a magnetic field. The stator has multiple coils that are energized in a specific sequence to produce a rotating magnetic field, which "pulls" the rotor to follow it.

### Key steps in Operation

#### 1. Hall Effect Sensors or Sensorless Control:

Position sensors (e.g., Hall Effect Sensors) detect the rotor's position and provide feedback to the controller. In sensorless designs, back-EMF (electromotive force) is used to infer position.

#### 2. Electronic Commutation

A microcontroller or dedicated driver IC (e.g., MOSFETs or IGBTs) switches current through the stator windings in pprecise sequence (typically 3-Phase: A,B,C). This creates a rotating magnetic field. 

#### 3. Torque Production

The stator field interacts with the rotor's permanent magnets, generating torque proportional to the current and the sine of the angle betwwen fields (ideally 90 degree for maximum torque).

#### 4. Spped Control

Achieved by varying the duty cycle (PWM - Pulse Width Modulation) or voltage applied to the phases.

The motor's speed is governed by the formula:

$$
    N=\frac{120\times f}{P}
$$

where N is the speed in RPM, f is the electrical frequency (Hz) and P is the number of poles

Torque T is roughly $T=K_t \times I$, where $K_t$ is the torque constant and $I$ is phase current.

BLDC motors can operate in trapezoidal (six step commutation, simpler) or sinusoidal (smoother, quieter) modes, with sinusoidal offering better efficiency and requiring more complex control.

## Components

### Rotor

- Permanent Magnets (e.g., neodynium for high strength). Can be surface-mounted (SPM) or interior-mounted (IPM) for different performance characteristics.

### Stator

- Laminated iron core with slotted windings (concentrated or distributed). Typically 3-phase, star or delta connected.

### Controller/Driver

- Includes inverter bridge (6 switches), microcontroller (e.g., STM32 or DSP), and sensors. Handles commutation logic and protection (overcurrent, overtemperature). This part is the Electronic speed controller (ESC) in the quadrotor.

### Sensors
 
- Hall effect (3 sensors for 60 degree resolution) or encoders for precise feedback. Sensorless uses algorithms like zero-crossing detection.

### Bearings and Housing

- Ball bearings for low friction; aluminium or steel housing for heat dissipation.

Power ratings range from milliwatts (e.g., phone vibrators) to kilowatts (e.g., EV traction motors up to 300 kW)

    
    