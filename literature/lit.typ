

== Overview
- (widely accepted) Runtime verification(properties): [13]
- Systems: [6, 23]
- Monitoring Correctness: [28]
- Fairness of Components: [29]
- Edge chasing: [_45, 54_]
- Simulation relation: [_45, 53_]
- _Algorithmic idea(seminal)_: [_17_, _44_]
- Improvements: [16, _17_, 19, _44_, _54_, 57]
- Process Calculi: [21, 22, 39–41, 47, 48]
- Delayed idea: [36, 42]  ← maybe these?
- _Wichtig_: [_37_]

== Todo
- [17, 44] their deadlock mechanism is _inline_ (cannot satisfy (2)(outline) and (3)transparency)

- @17deadlock_detection: complete, sound, distributed, Databases, Probes
- @30deadlock: ??
- @37formals: Formals
- @44distributed: Simple implementation using counters
- @54distributed: Inder, Probes, Edge-chasing

== Distributed Deadlock Detection @17deadlock_detection


== Literaturübersicht
The Paper `Correct Black-Box Monitors for Distributed Deadlock Detection: Formalisation and Implementation` has two main contributions: Firstly, it provides a novel deadlock algorithm but even more importantly, it provides computer verified formalisation of nodes, networks, monitors and message passing in an RPC framework. The papers references give inspiration for the edge-chasing algorithm and provide preliminary formulation methods in form of LTS-semantics.


=== The Edge-Chasing Paradigm and Protocol Optimization

The primary paper's decentralized monitoring logic is directly rooted in the "edge-chasing" paradigm popularized by Chandy, Misra, and Haas (1983) @17deadlock_detection. Chandy et al. demonstrated that deadlocks could be identified without maintaining a centralized global _wait-for graph_ by propagating localized "probe" messages across the network to detect cycles among idle processes. Building upon this, Mitchell and Merritt @44distributed introduced streamlined algorithms ensuring that only a single process in a cycle detects the deadlock, thereby vastly simplifying resolution. Crucially, the primary paper shifts away from forward-moving probes in favor of the backward-moving probe technique shown by Mitchell and Merritt. This architectural decision allows them to sidestep subtle false positives that can happen in the forward-moving probe algorithm.

Sinha and Natarajan (1985) @55priority make edge-chasing efficiency by incorporating priority-based timestamps. Their algorithm initiates probes only during "antagonistic conflicts" — when a transaction waits for one with a lower priority — drastically reducing communication overhead and preventing the detection of phantom deadlocks in fault-free environments. The primary paper leverages these optimization strategies to ensure its monitoring proxies remain lightweight and do not become bottlenecks in large-scale RPC systems.

=== Formal Verification and Operational Semantics

While early edge-chasing algorithms were conceptually strong, they often lacked the strict operational semantics required for verifiable black-box monitoring. To bridge this gap, the primary paper turns to the formalisms established by Keller (1976) @37formals. Keller modeled parallel computations as _Transition Systems_, where processes and computations are represented by discrete state transitions. By adopting Keller’s Labelled Transition System (LTS) semantics, the primary paper rigorously models networks of Single-threaded Remote Procedure Call (SRPC) services. This mathematical grounding is what fundamentally enables the primary paper to mechanically prove monitor transparency and correctness in the Coq theorem prover.

=== Mitigating False Positives and System Anomalies
The demand for mathematical precision in network states is heavily underscored by Gligor and Shattuck (1980) @30deadlock, who exposed the vulnerabilities of early distributed deadlock protocols. Through targeted counterexamples, they illustrated how arbitrary network delays and out-of-order graph updates generate "ostensibly blocked transactions," ultimately leading to false (phantom) deadlocks. Gligor and Shattuck’s cautionary findings directly inform the primary paper’s stringent correctness criteria. By demanding both "soundness" and "completeness," the primary paper establishes verifiable invariants ensuring that monitors only report actual deadlocks, neutralizing the anomalies Gligor and Shattuck originally identified.

=== Transactional Dependencies and Concurrency Control

Finally, managing distributed deadlocks requires a precise understanding of the underlying resource dependencies, a concept comprehensively addressed by Moss (1981) @54distributed. Moss extended traditional single-level transaction systems to support nested transactions, introducing strict two-phase locking rules and state restoration algorithms to maintain failure atomicity and concurrency control. Although the primary paper is tailored toward RPC service deadlocks rather than database transaction management, Moss's framework for handling distributed locking and wait dependencies clarifies the complex hierarchical network behaviors that modern edge-chasing monitors must correctly interpret and navigate.

- @43 defines a simulation relation for abstract processes.

#bibliography("literature/all.bib")
