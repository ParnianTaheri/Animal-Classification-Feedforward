# Feedforward Architecture for Rapid Categorization

This repository contains the implementation for the experiment described in the paper "A Feedforward Architecture Accounts for Rapid Categorization." The goal of the project is to compare human and machine performance in an animal vs non-animal categorization task using a feedforward neural network inspired by the Hubel and Wiesel simple-to-complex cell hierarchy theory, leveraging techniques like **Psychtoolbox** for human performance testing and **Support Vector Machine (SVM)** for machine classification.

## Overview

Humans are capable of rapid visual categorization, recognizing objects quickly under different conditions. This experiment seeks to determine if a computational model, inspired by the Hubel and Wiesel framework, can perform similarly. In particular, we explore the performance of both humans and machines using a dataset of animal and non-animal images.

### Key Features:
- **Feedforward Neural Architecture**: Inspired by Hubel and Wiesel's hierarchy of simple and complex cells.
- **Psychtoolbox**: Used to measure human performance in rapid visual categorization tasks.
- **SVM Classification**: A linear Support Vector Machine is applied to the dataset for machine learning.

## Techniques

### Hubel and Wiesel Model

The computational model used in this experiment is based on the Hubel and Wiesel theory of object recognition in the visual cortex. This theory proposes a hierarchical system where simple cells detect basic features like edges and orientations (S1 units), and complex cells (C1 units) combine those features to make the model robust to changes in scale and location. This process allows the machine to recognize objects across a variety of conditions, which is tested through the animal vs non-animal categorization task.

- **S1 Units**: Detect features such as edges and orientations.
- **C1 Units**: Max-pooling layers that make the model invariant to object scale and location.

### Psychtoolbox

**Psychtoolbox** is a set of MATLAB functions that provide precise control over visual and auditory stimuli presentation. It was used to simulate the rapid categorization task in human subjects. In this experiment, Psychtoolbox displayed the dataset images for a brief time (0.08 seconds) to replicate rapid recognition tasks, and it measured the participants' responses based on their accuracy, reaction time, and confidence.

Subjects were presented with 1200 images divided into 10 blocks. They had to indicate whether the image contained an animal using the keyboard. Psychtoolbox recorded several metrics:
- **Reaction time**: How fast the subject responded.
- **Accuracy**: The number of correct responses.
- **Confidence Level**: Recorded via a confidence bar after each response.

### Support Vector Machine (SVM) Classification

For machine classification, we used a **Linear SVM** model. The task of the machine was to categorize the same 1200 images (600 animals, 600 non-animals) into their respective categories. The images were converted to grayscale, and the dataset was split into training and testing sets. We used MATLAB’s `Classification Learner` app to train the SVM model, as it is a widely-used technique for binary classification tasks.

- **Training Set**: 600 grayscale images (300 animals, 300 non-animals).
- **Test Set**: 600 grayscale images (300 animals, 300 non-animals).

The trained SVM model was evaluated based on its accuracy and confusion matrix, which were compared to human performance metrics.


## Dataset

The dataset consists of 1200 RGB images of animals and non-animals. The images are categorized by proximity (close body, medium body, far body, and head). Before training the model, all images must be converted to grayscale.



## Results

### Machine Performance:
- **Accuracy**: 81.3% (SVM)
- Performance metrics (ROC curve, confusion matrix) can be visualized after training.

### Human Performance:
- **Accuracy**: 91.5%
- Metrics include reaction time, confidence levels, and accuracy across categories (close body, medium body, far body, head).

## Conclusion

This project highlights the disparity between human and machine performance in rapid visual categorization tasks. While the SVM model provides reasonable accuracy, it does not match human performance, particularly in recognizing objects at different distances (e.g., far body images).

## Contact

For any questions or contributions, feel free to contact Parnian Taheri at Parniantaheri.81@gmail.com.
