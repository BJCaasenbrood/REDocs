# Research proposal
\subsection*{Definitions}
Before detailing the topic of co-design, us first introduce some definitions. **Morphology**, from the context of biology, refers to the study of the form, structure, and material composition of organisms and their constituent parts, with emphasis on how these attributes determine function and facilitate environmental adaptation. This discipline investigates the relationship between anatomical features --- such as shape, size, and material organization --- and their functional and adaptive significance in evolutionary and ecological contexts. **Control**, on the other hand, encompasses algorithms by which the system's dynamics achieve a desired behavior. It is often relies on mathematical framework for designing control algorithms that govern system responses, ensuring stability, accuracy, and robustness under varying operational and environmental conditions. 

Sensor placement and actuator placement are critical considerations. Sensor placement involves determining the optimal locations for sensors to maximize observability, minimize noise, and ensure accurate state estimation. Strategic sensor positioning enables effective monitoring of system variables, facilitating robust feedback and enhancing control precision. Actuator placement, conversely, focuses on the spatial arrangement of actuators to achieve desired force transmission, responsiveness, and efficiency. The configuration of actuators directly influences the system's controllability and dynamic performance, affecting both stability and energy consumption. In advanced engineering applications, the co-optimization of sensor and actuator placement is increasingly recognized as essential for achieving superior system performance, particularly in environments demanding high accuracy and reliability.

An excellent example of applied morphology in engineering is found in soft robotics. Soft robots, a modern subdomain of robotics, leverage compliant materials to enhance adaptability and dexterity. The importance of morphology in facilitating control has been widely recognized within this research community, where designs are often inspired by biological systems that simplify controller design. However, in the broader field of engineering, the deliberate integration of morphology into controller design processes remains rare, despite its critical role in the development of **high-precision mechanical systems** that are increasingly demanded by the semiconductor industry and other advanced sectors. From a mechatronic perspective, the morphology of a mechanical system—including:
\begin{itemize}
  \item Geometric configuration
  \item Degrees of freedom
  \item Mass distribution
  \item Stiffness and damping properties
\end{itemize}
\noindent that together constitutes the fundamental aspects of its dynamic behavior. These morphological parameters govern the system's response to internal and external inputs and directly influence control design. Thus, while the terminology may differ across disciplines, the underlying principle persists: **structure dictates function**, whether in the study of natural organisms, soft robotics, or high-precision engineered systems.

## Problem statement
To highlight the importance of co-design as a framework, let us consider a few illustrative design problems. 

*Example 1 -- Disturbance-rejection*: Consider a mechanical structure mounted on a base subject to external vibrations, such as those induced by nearby machinery or environmental disturbances. The design objective is to develop an active structure whose morphology and control strategy are co-optimized to suppress the transmission of floor vibrations to the payload. 

Let $x(t)$ denote the displacement of the payload, and $y(t)$ the displacement of the vibrating floor. The system dynamics can be modeled as:
\[
M\ddot{x}(t) + C\dot{x}(t) + Kx(t) = F_{\text{act}}(t) + F_{\text{dist}}(t)
\]
where $M$, $C$, and $K$ represent the mass, damping, and stiffness matrices determined by the system's morphology, $F_{\text{act}}(t)$ is the actuator force, and $F_{\text{dist}}(t)$ is the disturbance force transmitted from the floor.

The co-design problem seeks to simultaneously optimize the placement and properties of sensors and actuators (morphology), as well as the control law $F_{\text{act}}(t)$, to minimize the effect of $F_{\text{dist}}(t)$ on $x(t)$. This can be formalized as:
\[
\min_{\text{morphology},\, \text{control}} \int_0^T \left| x(t) \right|^2 dt
\]
subject to physical constraints on mass, actuator limits, and sensor noise. The solution involves iterative refinement of both the mechanical configuration and the control algorithm to achieve robust disturbance rejection, demonstrating the necessity of co-design in high-precision environments.



## State-of-the-art in co-design
Co-design represents a recent paradigm shift in system engineering frameworks, emphasizing the simultaneous optimization of a mechanical system's morphology and its associated control strategies to maximize performance. Unlike traditional design approaches—which often treat mechanical design and control as sequential, independent processes—co-design seeks to exploit the synergistic relationship between structure and control, enabling the development of systems with superior precision, adaptability, and efficiency.



\begin{figure*}[!h]
  \includegraphics[width=\textwidth]{sampleteaser.pdf}
  \caption{1907 Franklin Model D roadster. Photograph by Harris \&
    Ewing, Inc. [Public domain], via Wikimedia
    Commons. (\url{https://goo.gl/VLCRBB}).}
\end{figure*}

\lipsum[2-3]
