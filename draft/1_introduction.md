\section*{\textbf{Research on computational co-design}}
<!-- Before discussing co-design, let us establish some key definitions. \textbf{Morphology}, a common term often coined in biology, refers to the study of the form, structure, and material composition of organisms and their constituent parts, with emphasis on how these attributes determine function and facilitate environmental adaptation. This discipline investigates the relationship between anatomical features --- such as shape, size, and material organization --- and their functional and adaptive significance in evolutionary context. **Control**, on the other hand, encompasses algorithms that govern (closed-loop) system dynamics to achieve desired behavior through mathematical frameworks ensuring stability, precision, and robustness under varying conditions. -->
**What is co-design?** Co-design refers to the integrated process of simultaneously optimizing both the physical structure that endows its function (morphology) and the control strategies of a system. Early examples of co-design include the pioneering works by Sims \cite{sims1994evolving,sims1991artificial} in the early 90s, which demonstrated the generative design of locomoting virtual creatures. Here, both the morphologies of the virtual organisms and their neuro-muscular control systems were evolved together using genetic algorithms. 
<!-- 
Over the past three decades, exponential advances in computational power have catalyzed the evolution of co-design into a broad and multifaceted research domain. Notably, recent years have witnessed significant progress in the application of co-design methodologies to (soft) robotics, as evidenced by a growing body of literature \cite{sato2023topology,sato2024computational,allison2013plantlimited}. This expansion reflects both the increasing complexity of engineered systems and the demand for integrated approaches that jointly optimize morphology and control. -->
Over the past three decades of research,
catalyzed by the persistent advancements in computational processing, the co-design has branched into a interdisciplinary research domain \cite{mirzendehdel2023codesign}. Notably, recent years have witnessed significant increase in co-design methodologies for (soft) robotic systems \cite{sato2023topology,sato2024computational,allison2013plantlimited,bravopalacios2020one}. 

<!-- {Morphology}, a common term often coined in biology, refers to the study of the form, structure, and material composition of organisms and their constituent parts, with emphasis on how these attributes determine function and facilitate environmental adaptation. This discipline investigates the relationship between anatomical features --- such as shape, size, and material organization --- and their functional and adaptive significance in evolutionary context. *Control*, on the other hand, encompasses algorithms that govern (closed-loop) system dynamics to achieve desired behavior through mathematical frameworks ensuring stability, precision, and robustness under varying conditions.  -->

**Open challenges**. Despite its recent academic resurgence, several critical shortcomings continue to limit its potential applicability.

First, co-design techniques are often burdened by high computational demands during optimization, which can hinder effective exploration of the design space. For example, in structural optimization with control feedback \cite{yuhn20234d,sato2024computational,strgar2025accelerated}, the system is frequently modeled as a time-dependent Partial Differential Equations (PDE). Traditionally, each optimization iteration requires explicit discretization of the spatial domain, followed by numerically solving the resulting discrete system over its relevant spatial and then temporal horizon, respectively. This sequential process is computationally expensive, especially as  dimensionality of the design space increase. Recent advances have sought to address these challenges by representing the geometry of the spatial domain implicitly, such as through level-set methods or neural implicit representations (see neural PDE-refiner \cite{lippe2023pderefiner, li2020fourier}). These approaches enable parametric design, where geometric modifications are encoded as continuous parameters, facilitating smooth and flexible exploration of the design space. Moreover, implicit representations enable direct PDE surrogate solutions without rediscretization, reducing computational overhead and supporting efficient optimization of complex, high-dimensional geometries in multidisciplinary co-design.

Second, there remains a significant gap on how to tailor *"good metrics"* related to *"good designs."* The issue here is twofold. On one hand, it is desirable to define metrics that are both computationally efficient and tractable, such that it facilitates fast evaluation and numerical adaptivity in the optimization process. On the other hand, these metrics must also capture vital aspects of design, e.g., manufacturability and design constraints, production cost, product lifespan and maintainability, robustness, and compliance with regulatory standards. The balance between computational tractability and practical relevance often necessitates a hierarchical or multi-fidelity approach: initial optimization may rely on simplified, computationally inexpensive metrics to broadly explore the design space and avoid premature convergence to local minima, followed by progressive refinement using higher-fidelity, more computationally intensive evaluations that gradually improving design confidence.

Third, a persistent challenge in co-design is the disparity between simulation-based design (sim) and real-world deployment (real), commonly referred to as the *"Sim2Real* gap. This gap arises due to modeling inaccuracies, unmodeled dynamics, and inherent oversimplifications of simulation environments in favor of computation, which can result in suboptimal or even infeasible designs when transferred to physical systems. Recent advances in data-driven modeling offer promising avenues to mitigate these discrepancies. By leveraging empirical data collected from real-world experiments, data-driven approaches can refine simulation models, improve parameter estimation, and adapt control strategies to better reflect actual system behavior. 
<!-- Integrating such methods into the co-design workflow holds the potential to reduce the sim-to-real gap, thereby enhancing the reliability and robustness of co-designed solutions in practical applications. -->

Finally, the inherently multidisciplinary nature of co-design necessitates the involvement of diverse stakeholders throughout the entire design process. However, current state-of-the-art co-design methodologies frequently fall short in systematically integrating input from a broad range of perspectives or adequately addressing the full spectrum of its end-user requirements.

<!-- Before examining co-design, we establish key definitions. **Morphology** refers to the study of form, structure, and material composition of organisms, emphasizing how these attributes determine function and environmental adaptation. **Control** encompasses algorithms that govern system dynamics to achieve desired behavior through mathematical frameworks ensuring stability, accuracy, and robustness under varying conditions. -->

<!-- Sensor placement and actuator placement are critical considerations. Sensor placement involves determining the optimal locations for sensors to maximize observability, minimize noise, and ensure accurate state estimation. Strategic sensor positioning enables effective monitoring of system variables, facilitating robust feedback and enhancing control precision. Actuator placement, conversely, focuses on the spatial arrangement of actuators to achieve desired force transmission, responsiveness, and efficiency. The configuration of actuators directly influences the system's controllability and dynamic performance, affecting both stability and energy consumption. In advanced engineering applications, the co-optimization of sensor and actuator placement is increasingly recognized as essential for achieving superior system performance, particularly in environments demanding high accuracy and reliability.

An excellent example of applied morphology in engineering is found in soft robotics. Soft robots, a modern subdomain of robotics, leverage compliant materials to enhance adaptability and dexterity. The importance of morphology in facilitating control has been widely recognized within this research community, where designs are often inspired by biological systems that simplify controller design. However, in the broader field of engineering, the deliberate integration of morphology into controller design processes remains rare, despite its critical role in the development of **high-precision mechanical systems** that are increasingly demanded by the semiconductor industry and other advanced sectors. From a mechatronic perspective, the morphology of a mechanical system—including:
\begin{itemize}
  \item Geometric configuration
  \item Degrees of freedom
  \item Mass distribution
  \item Stiffness and damping properties
\end{itemize}
\noindent that together constitutes the fundamental aspects of its dynamic behavior. These morphological parameters govern the system's response to internal and external inputs and directly influence control design. Thus, while the terminology may differ across disciplines, the underlying principle persists: **structure dictates function**, whether in the study of natural organisms, soft robotics, or high-precision engineered systems. -->

\section*{\textbf{Proposed research framework}}

**Problem statement.** To underscore the significance of co-design as a methodological framework, consider the illustrative design scenarios depicted in Fig. 1 and Fig. 2. The first example addresses a disturbance-rejection problem, which is particularly relevant in high-precision industries such as semiconductor manufacturing. The second example focuses on the design of a docking interface, with applications in space engineering and advanced robotics. These cases exemplify the diverse challenges that co-design methodologies are well-positioned to address, highlighting the need for integrated optimization of both morphology and control strategies to achieve robust and adaptable system performance.
<!-- *Example 1 -- Disturbance-rejection*: Consider a mechanical structured subject to external vibrations, such as those induced by nearby machinery or environmental disturbances. The design objective is to develop an active structure whose morphology and control strategy are co-optimized to suppress the transmission of floor vibrations to the payload.  -->

\begin{figure}[!t]
  \centering
  \includegraphics[width=\columnwidth]{./img/drawing2}
  \vspace{-4mm}
  \caption{Example 1: Co-design problem tailored towards finding an optimal morphology $\mathcal{M}$ with internal sensing $\mathbf{y}$ and actuation $\mathbf{u}$ such it suppress the disturbance $w(t)$ at the interface of $\mathcal{M}$. \vspace{-4mm}}
\end{figure}
\begin{figure}[!t]

  \centering
  \includegraphics[width=\columnwidth]{./img/drawing3}
  \caption{Example 2: }
  \vspace{-4mm}
\end{figure}

**Problem formulation.**  A (compliant) mechatronic system can be described by a morphological descriptor $\mathcal{M}(\mathcal{G}, \mathsf{B}, \mathsf{M}, \mathsf{K})$, where $\mathcal{G}$ denotes the topological graph, $\mathsf{B} = \left\{\mathbf{B}_1, ..., \mathbf{B}_n\right\}$ represents the set of body frames for relevant components (such as actuators and sensors) with each $\mathbf{B}_i \in SE(3)$, and $\mathsf{M}$, $\mathsf{K}$, and $\mathsf{D}$ correspond to the collections of mass and stiffness of each body frame $\mathbf{B}_i$. 

To facilitate the parametrization of $\mathcal{M}$, assume the existence of a decoder function $E$ that maps a set of continuous design variables $\mathbf{\theta}$ to a specific morphological configuration, i.e., $E: \mathbf{\theta} \mapsto \mathcal{M}_\theta$. For each parametrized design $\mathcal{M}_\theta$, the system's minimal state representation can be expressed in terms of the state variables $\mathbf{x} = (\mathbf{q}, \dot{\mathbf{q}})$ and the actuation space $\mathbf{u}$. This formulation yields the structural dynamics as $\dot{\mathbf{x}} = \mathbf{f}(\mathbf{x}, \mathbf{u}; \mathcal{M}_\theta)$ which may be regarded as an time-evolution encoding given an initial condition $\mathbf{x}_0$. An illustrative example of morphological decoding is given in Fig 3.

As such, we may generalize the co-design problem as a mathematical optimization of the following form:
\begin{equation}
\begin{aligned}
  &\underset{\mathbf{\theta},\,\mathbf{x}(\cdot), \mathbf{u}(\cdot)}{\text{argmin}}
  && \int_{t_1}^{t_2} J(\mathbf{x}(\tau),\mathbf{u}(\tau)) \; d\tau \\
  &\text{subject to}
  && \dot{\mathbf{x}}(t) = f(\mathbf{x}(t), \mathbf{u}(t); \mathcal{M}), \quad \forall t \in [t_1,t_2], \\
  &&& \mathbbf{\theta} \subseteq \mathcal{D}; \;\; \mathbf{x} \subseteq \mathcal{X}; \;\;  \mathbf{u} \subseteq \mathcal{U},
\end{aligned}
\label{eq:optimization_problem}
\end{equation}
where $\mathcal{D}$, $\mathcal{X}$ and $\mathcal{U}$ are the admissible (design) spaces of the morphology, state trajectories and control action, respectively.

This formulation yields a complex mathematical optimization problem often characterized by a high-dimensional decision space. Consequently, careful consideration must be given to decomposing the problem into computationally tractable subproblems to facilitate efficient solution strategies.

**Research scope.** Solving an optimization problem of the form \ref{eq:optimization_problem} requires a system decomposition of the problem. The body of research can be categorized in three main topics:

\begin{figure}[!t]
  \includegraphics[width=\columnwidth]{./img/drawing}
  \caption{Numerical examples of Karl Sims co-design of artificial-life locomoting creatures}
  \vspace{-4mm}
\end{figure}

*i) Implicit encoding of morphology.* Recent advances in computational design have introduced implicit encoding techniques for representing morphology, such as level-set methods, neural implicit representations and material-point particles. Unlike explicit geometric models, implicit encodings describe shapes and structures as continuous functions over spatial domains, enabling flexible and differentiable parametrization of complex geometries. This approach facilitates smooth exploration of the design space and supports gradient-based optimization, which is particularly advantageous for high-dimensional co-design problems. Moreover, implicit representations allow for direct integration with simulation and surrogate modeling frameworks, reducing the need for repeated discretization and accelerating the evaluation of candidate designs. As a result, implicit encoding has emerged as a powerful tool for enabling scalable and efficient co-design of compliant and soft robotic systems.

*ii) Reduced-order dynamics.* Given a morphological description, it is essential to derive the system's intrinsic dynamics in a computationally efficient manner. Typically, the underlying physics are governed by Partial Differential Equations (PDEs), which describe the evolution of system states over space and time. However, directly solving high-dimensional PDEs for each design iteration is computationally prohibitive. To address this, reduced-order modeling techniques are employed to approximate the system dynamics using a lower-dimensional set of state variables, preserving essential behavior while significantly reducing computational cost. Recent advances, such as neural PDE-refiner methods \cite{lippe2023pderefiner, li2020fourier}, leverage data-driven surrogate models to learn efficient mappings from design parameters to system responses. These approaches enable rapid evaluation of candidate morphologies by implicitly encoding the solution space and bypassing repeated discretization. By selecting appropriate state variables and constructing reduced-order models, the optimization process becomes tractable, facilitating scalable co-design of complex systems with PDE-based dynamics.


Co-design represents a recent paradigm shift in system engineering frameworks, emphasizing the simultaneous optimization of a mechanical system's morphology and its associated control strategies to maximize performance. Unlike traditional design approaches—which often treat mechanical design and control as sequential, independent processes—co-design seeks to exploit the synergistic relationship between structure and control, enabling the development of systems with superior precision, adaptability, and efficiency.

<!-- \lipsum[2-3] -->