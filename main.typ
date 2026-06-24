#import "@preview/touying:0.7.4": *
#import themes.simple: *

== Aufbau
1. Motivation
2. Formalisierung erarbeiten
3. Soundness & Completeness Proofs (Sketch?)
4. Deadlock Algorithm


== Ziel
> Ich möchte, anhand der Typregeln ein paar nice Graphen zeigen
> Ich möchte die formalen Properties aufzeigen
> Ich möchte den Algorithmus zeigen

== Pro Slide
- Nicht zu sehr auf die Einzelheiten (die dort stehen)
- Sondern mehr auf die Intuition und slides as "reference"
- An sich aber eigentlich: auf slides nur wichtiges ↯
- Dafür vielleicht den Rest einfach ausgrauen?
- Oder doch einfach massiv viele Slides?

== Todo
- what is c
- why service s?
- SER-TI und SER-TO?
- was macht der τ-wrapper?


== Keywords
- *Message Passing*: Query, Response, Cast
- *Remote Procedure Calls*
- *Deadlock*: Cyclic wait
- *Monitors*: Analyse traffic
  - Probes: Communication with other monitors
- *Black-Box*: No introspection

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

== Todo
- Probing
- Process Calculi?
- SRPC relation to RPC?


#show: simple-theme.with(aspect-ratio: "16-9")

= Correct Black-Box Monitors for Distributed Deadlock Detection: Formalisation and Implementation

== Disecting the Title
- We are given a network setting with communicating RPC Services
- *RPC*: Remote Procedure Call (Query, Response, Cast)
- *Deadlock*: Cyclic waiting for resources in such a network
- *Distributed*: No central authority (due to performance)
- *Blackbox*: No introspection of services, only communication behaviour
- *Monitors*: Wrappers around service that observe communication

== Contributions
1. A formal model for RPC services and communication
2. A formal method to install  distributed, black-box, outline monitors
3. A Monitoring algorithm that detects deadlock in a sound and complete way and proof its soundness
4. Implementation of DDMon (for Erlang/OTP)


== Agenda
1. Formalising Processes & Services
2. Formalising Networks
3. Installing Monitors
4. Proof for Deadlock-detection
5. Deadlock Detection Algorithm
6. Proof of Soundness & Completeness


== Wanted Properties
1. *Distributed*: No centralized component
2. *Blackbox and Outline*: Detect deadlocks by just observing the incoming and outgoing messages of the service they monitor
3. *Transparent*: Don't alter the execution
4. *Precise*: Detect Deadlock iff it existst

#let Name(block) = text(fill: gray, block)

#set text(size: 18pt)

= Nodes
== Formalism: Services
- We define _Single-threaded Remote Procedure Calls_ (SRPC)

#v(1cm)
$
  Name("Communication tag") && t & := Q | R | C
  &&& Name("Name") && n & := n₀ | n₁ | … \
  Name("Client") && n^⊥ & := n | ⊥
  &&& Name("Process") && P & := … \
  Name("Queue") && q & := ε | n(t) | q ⧺ q
  &&& Name("Service") && S & := ⟨q^i | P | q^o⟩ \
$
#v(1cm)
- The Behaviour of P must be compatible with an *abstract SRPC Process G*



== Formalism: LTS Semantic of abstract SRPC Process G
- We define the possible states of an abstract Process G. The LTS Semantics are defined in @sem-process using the transitions labels γ.

#v(1cm)
$
  G & := "Ready" | "Working"(n_c^⊥) | "Locked"(n_c^⊥, n_s) \
  γ & := ?n(t) | !n(t) | τ
$

#figure(
  caption: "LTS semantics of the abstract SRPC process G",
  image("./assets/Fig1.png"),
) <sem-process>

// add the funny circly image?


== Formalism: LTS Semantic of Services
- We extend a process P with queues and search operations to form a service S. The lts-semantics in @lts-service are using the transition labels in β. δ is a transition label for queues.
$
  δ & := ![n(t)] \
  β & := ?n(t) | !n(t) | τ(?n(t)) | τ(!n(t)) | τ(τ)
$

#figure(
  caption: "LTS semantics of services",
  image("./assets/Fig4.png"),
) <lts-service>

= Networks
== Formalism: Network
$
  α := τ(γ \@ n) | n₀ –(t)→ n₁
$

#figure(
  caption: "LTS semantics of services",
  image("./assets/Fig5.png"),
)

= Monitors
== Formalism: Monitors
- We define a monitored Service Ŝ:
$
  hat(m) & := ?n(t) | !n(t) | ?n(hat(p)) | !n(hat(p)) \
  hat(q) & := ε | hat(m) | hat(q) ⧺ hat(q) \
  hat(S) & := ⟨hat(q) | P | S⟩ \
$

- With Monitored service action:
$
  hat(β) := β | ?n(hat(p)) | !n(hat(p)) | hat(τ)(?n(t)) | hat(τ)(!n(t)) | hat(τ)(?n(hat(p)))
$

- A monitored Service: $⟨ hat(q) | hat(M) | S⟩$
Monitor algorithm function: $hat(𝓐): hat(𝓜) × hat(𝔪) -> hat(𝓜) × hat(𝔮)$

== Slide
#figure(
  caption: "LTS semantics of monitored networks & visualization of communication.",
  image("./assets/Fig9_10.png"),
)


== Formalism: Monitored Network action
- The lts-semantics given in @lts-monitor-nets is using the transition labels $hat(α)$
$
  hat(α) := α | hat(τ)(γ \@ n) | n₀ -(hat(p))-> n₁
$

#figure(
  caption: "LTS semantics of monitored networks",
  image("./assets/Fig11.png"),
) <lts-monitor-nets>


= Instrumentation
- Monitor instrumentation: $𝓜 : 𝓝 -> hat(𝓝)$
- Deinstrumentation: $𝓜^(-1): hat(𝓝) → 𝓝$


== Formalism: Deadlocks Set
- Todo: Deadlock of single node
- Todo: Deadlock set


= The Algorithm
- Monitor states $hat(M)$ is a record with the fields "probe" | "waiting" | "alarm"
- Implementation of $hat(𝓐)$

#figure(
  caption: "Implementation of 𝓐",
  image("./assets/Fig12.png"),
) <alg>


#figure(
  caption: "Deadlock detection algorithm example with three nodes.",
  image("./assets/Fig13.png"),
) <example>



= Correctness Proofs
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
