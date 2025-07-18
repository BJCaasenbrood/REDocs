# Research proposal
Before discussing co-design, let us establish some key definitions. \textbf{Morphology}, a common term often coined in biology, refers to the study of the form, structure, and material composition of organisms and their constituent parts, with emphasis on how these attributes determine function and facilitate environmental adaptation. This discipline investigates the relationship between anatomical features --- such as shape, size, and material organization --- and their functional and adaptive significance in evolutionary context. **Control**, on the other hand, encompasses algorithms that govern (closed-loop) system dynamics to achieve desired behavior through mathematical frameworks ensuring stability, precision, and robustness under varying conditions.

<!-- Before examining co-design, we establish key definitions. **Morphology** refers to the study of form, structure, and material composition of organisms, emphasizing how these attributes determine function and environmental adaptation. **Control** encompasses algorithms that govern system dynamics to achieve desired behavior through mathematical frameworks ensuring stability, accuracy, and robustness under varying conditions. -->

Sensor placement and actuator placement are critical considerations. Sensor placement involves determining the optimal locations for sensors to maximize observability, minimize noise, and ensure accurate state estimation. Strategic sensor positioning enables effective monitoring of system variables, facilitating robust feedback and enhancing control precision. Actuator placement, conversely, focuses on the spatial arrangement of actuators to achieve desired force transmission, responsiveness, and efficiency. The configuration of actuators directly influences the system's controllability and dynamic performance, affecting both stability and energy consumption. In advanced engineering applications, the co-optimization of sensor and actuator placement is increasingly recognized as essential for achieving superior system performance, particularly in environments demanding high accuracy and reliability.

An excellent example of applied morphology in engineering is found in soft robotics. Soft robots, a modern subdomain of robotics, leverage compliant materials to enhance adaptability and dexterity. The importance of morphology in facilitating control has been widely recognized within this research community, where designs are often inspired by biological systems that simplify controller design. However, in the broader field of engineering, the deliberate integration of morphology into controller design processes remains rare, despite its critical role in the development of **high-precision mechanical systems** that are increasingly demanded by the semiconductor industry and other advanced sectors. From a mechatronic perspective, the morphology of a mechanical system—including:
\begin{itemize}
  \item Geometric configuration
  \item Degrees of freedom
  \item Mass distribution
  \item Stiffness and damping properties
\end{itemize}
\noindent that together constitutes the fundamental aspects of its dynamic behavior. These morphological parameters govern the system's response to internal and external inputs and directly influence control design. Thus, while the terminology may differ across disciplines, the underlying principle persists: **structure dictates function**, whether in the study of natural organisms, soft robotics, or high-precision engineered systems.

\begin{figure}[!t]
  \includegraphics[width=\columnwidth]{./img/sims.png}
  \caption{Numerical examples of Karl Sims co-design of artificial-life locomoting creatures}
\end{figure}

## Problem statement
To highlight the importance of co-design as a framework, let us consider a few illustrative design problems.

*Example 1 -- Disturbance-rejection*: Consider a mechanical structured subject to external vibrations, such as those induced by nearby machinery or environmental disturbances. The design objective is to develop an active structure whose morphology and control strategy are co-optimized to suppress the transmission of floor vibrations to the payload. 
## State-of-the-art in co-design
Co-design represents a recent paradigm shift in system engineering frameworks, emphasizing the simultaneous optimization of a mechanical system's morphology and its associated control strategies to maximize performance. Unlike traditional design approaches—which often treat mechanical design and control as sequential, independent processes—co-design seeks to exploit the synergistic relationship between structure and control, enabling the development of systems with superior precision, adaptability, and efficiency.

\lipsum[2-3]
