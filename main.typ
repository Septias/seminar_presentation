
#import "@preview/touying:0.7.4": *
#import themes.simple: *

#show: simple-theme.with(aspect-ratio: "16-9")

== Todo
- Was ist eine LTS Semantic?


== Paper Ablauf
1. Was ist RPC
2. Warum sind Deadlocks blöd
3. Warum sind die schwer zu finden
4. _false positives_ in sound static analysis


== Aufbau
1. Motivation
2. Formalisierung erarbeiten
3. Soundness & Completeness Proofs (Sketch?)
4. Deadlock Algorithm


== Keywords
- Message Passing: Query, Response, Cast
- Remote Procedure Calls
- Deadlock: Cyclic wait
- Monitors: Analyse traffic
  - Probes: Communication with other monitors
- Black-Box: No introspection


== Umsetzung
- Viele Visualisierungen vom Netzwerk wären nice
  - Aus dem Paper?
    - Easy aber arsch Quali
  - Mit diesem Graphen CLI-Tool?
  - Mit Anki?
  - Mit Typst?


== Quirks
- The monitored path might be different!

== Proofs and Definitions
- Criterion 2.1 (Monitor Instrumentation Transparency)
  - Operational Correspondance vs. Simulation Relation
  - soundess allows some extra steps
- Criterion 2.2 (Preciseness of Deadlock Detection)
  - completeness allows some extra steps
- Lock
- Deadlock
- Deadlockset
- Lemma 3.8 (Persistence of deadlocks).


= Slides
== Motivation
- Deadlocks sind blöd
- Bild von Deadlock


== Setting
- Netzwerk
- (S)RPC- Bild von Deadlock
- Blackbox


== Monitors
1. Distributed without introducing centralized component
2. Blackbox and outline: Detect deadlocks by just observing the incoming and outgoing messages of the service they monitor
3. Transparent: Don't alter the execution
4. Precise: Detect Deadlock iff it existst


== Formalism
Network: N
Monitored Network: hat(N)
Transitions: N →^{α} N'
Many Transitions(path): N →^{σ} N'
Instrumentation: ℳ
De-instrumentation: ℳ^(-1)

= Nodes
== Formalism: Services
t := Q | R | c
n := n0 | n1 | …
n^⊥ := n | ⊥
P := …
q := ε | n(t) | q ++ q
S := ⟨q^i | P | q^o⟩


== Formalism: LTS Semantic of abstract SRPC Process G
G := Ready | Working | Locked
γ := ?n(t) | !n(t) | τ
We turn a Service S into a Process G


== Formalism: LTS Semantic of Service
δ := ![n(t)]
β := ?n(t) | !n(t) | τ(?n(t)) | τ(!n(t)) | τ(τ)

= Networks
== Formalism: Network
- We write 𝑁(𝑛) to denote the service named 𝑛within 𝑁
- We write N for the set of all networks.
α := τ(γ \@ n) | n₀ -(t)-> n₁


== Formalism: Deadlocks
- TODO


= Monitors
== Formalism: Monitors
hat(m) := ?n(t) | !n(t) | ?n(hat(p)) | !n(hat(p))
hat(q) := ε | hat(m) | hat(q) ++ hat(q)
hat(S) := ⟨hat(q) | P | S⟩

Monitored service action:
hat(β) := β | ?n(hat(p)) | !n(hat(p)) | hat(τ)(?n(t)) | hat(τ)(!n(t)) | hat(τ)(?n(hat(p)))
τ being the internal actions

Monitor algorithm function: hat(𝓐)
- This function is total


== Formalis: Monitored Network action
hat(α) := α | hat(τ)(γ \@ n) | n₀ -(hat(p))-> n₁
monitored path: hat(σ)


= Instrumentation
Monitor instrumentation: 𝓜 : 𝓝 -> hat(𝓝)
Deinstrumentation: 𝓜^(-1)
Monitor stripping operation: hat(S)↓: $⟨hat(q) | hat(M) | ⟨q^i | P | q^o⟩⟩ = ⟨q^i ++ "filter"^i(hat(q)) | P | q^o ++ "filter"^o(hat(q)) ++ q^o⟩$
Stripping of monitor path: hat(σ)↓: …


== Theorem 4.8 (Black-box instrumentation transparency — completeness).


= The Algorithm
- Monitor states hat(M): probe | waiting | alarm
- Implementation of hat(𝓐)


= Wellformedness of SRPC
- Definition: Initial Network
- Definition: Client
- Definition: SRPC well-formedness
- Definition: Wellformed SRPC Network
- Theorem: Wellformedness as an _invariant_
- Definition: Complete Lock Knowledge
- Definition: Alarm Condition
- Definition: Sound lock knowledge
- Theorem: Sound lock knowledge is an _invariant_
- Theorem 6.13 (Deadlock detection preciseness)
- Theorem 6.13 (eventual deadlock reporting)


= Evaluation
- Overhead is neglectible
