#!/usr/bin/env python3
"""Generate simple WAV sound effects for the FLAMES Love Game."""

import struct
import math
import wave
import os

SAMPLE_RATE = 44100

def generate_tap(filename: str):
    """Generate a short 'click' sound (~80ms)."""
    duration = 0.08
    num_samples = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(num_samples):
        t = i / SAMPLE_RATE
        # Short sine chirp with quick decay
        freq = 800 + (t / duration) * 600  # 800->1400 Hz sweep
        envelope = max(0, 1 - t / duration)  # linear decay
        # First 5ms is silence (avoid pop)
        if t < 0.005:
            envelope = 0
        value = int(16000 * envelope * math.sin(2 * math.pi * freq * t))
        samples.append(value)

    _write_wav(filename, samples)

def generate_reveal(filename: str):
    """Generate a pleasant ascending chime (~400ms)."""
    duration = 0.4
    num_samples = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(num_samples):
        t = i / SAMPLE_RATE
        # Ascending arpeggio: C5 -> E5 -> G5 -> C6
        base_freq = 523  # C5
        if t < 0.1:
            freq = base_freq
        elif t < 0.2:
            freq = 659  # E5
        elif t < 0.3:
            freq = 784  # G5
        else:
            freq = 1047  # C6
        
        # Envelope: attack (10ms), sustain, then decay (last 80ms)
        attack = min(1.0, t / 0.01)
        decay = max(0, min(1.0, (duration - t) / 0.08))
        envelope = attack * decay
        
        # Add harmonics for richer sound
        value = int(12000 * envelope * (
            0.6 * math.sin(2 * math.pi * freq * t) +
            0.3 * math.sin(2 * math.pi * freq * 2 * t) +
            0.1 * math.sin(2 * math.pi * freq * 3 * t)
        ))
        samples.append(value)

    _write_wav(filename, samples)

def generate_button_tap(filename: str):
    """Generate a soft UI tap sound (~50ms)."""
    duration = 0.05
    num_samples = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(num_samples):
        t = i / SAMPLE_RATE
        # Quick high-frequency click at 2kHz with fast decay
        freq = 2000
        envelope = math.exp(-t * 80)  # Fast exponential decay
        value = int(12000 * envelope * math.sin(2 * math.pi * freq * t))
        samples.append(value)

    _write_wav(filename, samples)

def _write_wav(filename: str, samples: list):
    """Write samples as a 16-bit mono WAV file."""
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with wave.open(filename, 'w') as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)  # 16-bit
        wf.setframerate(SAMPLE_RATE)
        # Clamp samples to 16-bit range
        wf.writeframes(struct.pack('<' + 'h' * len(samples),
                                   *[max(-32768, min(32767, s)) for s in samples]))
    print(f"  Created: {filename} ({len(samples)} samples, {len(samples)/SAMPLE_RATE:.2f}s)")

if __name__ == '__main__':
    assets_dir = os.path.join(os.path.dirname(__file__), 'assets', 'sounds')
    print("Generating FLAMES sound effects...")
    generate_tap(os.path.join(assets_dir, 'tap.wav'))
    generate_reveal(os.path.join(assets_dir, 'reveal.wav'))
    generate_button_tap(os.path.join(assets_dir, 'button_tap.wav'))
    print("Done!")
