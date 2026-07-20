

== Overview
- Monitoring Correctness: [28]
- Fairness of Components: [29]
- Operational Correspondance: [31]
- Simulation relation: [43, 53]

- Process Calculi: [21, 22, 39–41, 47, 48]
- Delayed idea: [36, 42]  ← maybe these?

== Main
- _Algorithmic idea(seminal)_: [_17_, _44_]
- Edge chasing: [_45, 54_]
- Simulation relation: [_45, 53_]
- Improvements: [16, _17_, 19, _44_, _54_, 57]
- _Wichtig_: [_37_]


== Todo

- [x] @17deadlock_detection: complete, sound, distributed, Databases, Probes
- @30deadlock: ??
- @37formals: Formals
- [x] @44distributed: Simple implementation using counters
- @45nested:
- [x] @54priority: Inder, Probes, Edge-chasing



== Literaturübersicht
The Paper `Correct Black-Box Monitors for Distributed Deadlock Detection: Formalisation and Implementation` has two main contributions: It provides a novel deadlock algorithm that is proven sound & complete and secondly, it is the first paper to provide full LTS-semantics of nodes, networks, monitors, the installation of monitors and message passing in an RPC framework. We discuss the primary references that introduce the seminal idea of the algorithm (edge-chasing), techniques for distributed deadlock detection and the LTS-semantics.


=== Edge-Chasing and Protocol Optimization
The deadlock algorithm of the main paper @main is based upon the _edge-chasing_ paradigm introduced in @17deadlock_detection @45nested for a distributed database model (DBB). The paper shows how deadlocks can be identified without maintaining a centralized global _wait-for graph_ by propagating "probe" messages in the network. The formalization is not mechanically verified and differs in the use of "controllers" that communication has to pass through in the communication model that is also limited to messages of kind query and response only (@main also has casts). They use a similar notion of _dependent sets_ to find a group of permanently idle processes, though not fully formal. A problem of their algorithms is that multiple nodes can start the detection scheme simultaneously, increasing the algorithmic cost.

@44distributed solve this problem by ensuring that only a single process in a cycle detects the deadlock. The algorithms can be adjusted to use priorities or arbitrary nodes that can then decide to abort or otherwise break the deadlock. The primary paper uses the same backward-moving probe technique shown by this paper which sidestep subtle false positives that can happen in the forward-moving probe algorithm. Their algorithm may still admit false positives caused by process failures.

Sinha and Natarajan (1985) @54priority make edge-chasing efficient by incorporating priority-based timestamps. Their algorithm initiates probes only during "antagonistic conflicts" — when a transaction waits for one with a lower priority. This reduces communication overhead and prevents the detection of phantom deadlocks in fault-free environments. The same technique is used in @main. Their algorithm does not need extra computation but is not applicable to detect communication deadlocks. Due to the storage of old probes, cyclic restart can be mitigated and using the priority numbers, the message complexity can be computed exactly.


=== Formal Verification and Operational Semantics

@main relies on the LTS-semantics of @37formals. Keller modeled parallel computations as _Transition Systems_, where processes and computations are represented by discrete state transitions and provide an inductive principle which can be used to prove correctness. Their proofs are _informal_ though.


=== Performance Improvements and Edge Cases
@30deadlock expose the vulnerabilities of early distributed deadlock protocols and show the significance of formal correctness proofs. They show how arbitrary network delays and out-of-order graph updates generate shallow blocked transactions, that lead to false (phantom) deadlocks. By demanding both "soundness" and "completeness," @main establishes verifiable invariants ensuring that monitors only report actual deadlocks, neutralizing the anomalies Gligor and Shattuck originally identified.


=== Conclusion
While the algorithmic idea of @main is a direct descendant of prior work @17deadlock_detection @44distributed @54priority, they mitigate some false positives by using backward-moving probes and close a huge gap in formalization.


#bibliography("./all.bib")
