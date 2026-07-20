#import "@preview/touying:0.7.4": *
#import themes.simple: *

#let hidden = [
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


  == Proofs and Definitions
  2.1 Transparency of monitors p.5 (sound & complete)
  2.2 Preciseness of deadlock detection p.5 (sound & complete)
  3.6 Lock p.9
  3.7 Deadlock p.9
  4.4 Monitor instrumentation p.12
  4.5 Monitor de-instrumentation p.12
  4.6 Prop: M^(-1)(M(N)) = N
  4.8 Back-box instrumentation transparency complete
  4.11 Back-box instrumentation transparency sound
  5.1 Equivalence Between Deadlocks and Lock-on cycles
  5.2 Deadlock Detection Algortihm p.14
  6.1 Definition: Initial network and instrumentation p.16
  6.2 Definition: Client p.16
  6.3 Definition of well-formed SRPC client & server p.17
  6.7 !Complete lock knowledge p.18
  6.8 Alarm condition p.18
  6.9 Alarm condition leads to alarm p.18
  6.10 _Complete_ lock knowledge leads to invariant p.19
  6.11 Sound lock knowledge
  6.12 Sound lock knowlegdge is an invariant
  6.13 Deadlock Detection Preciseness
  6.14 Eventual Deadlock Reporting


  - Deadlockset
  - Lemma 3.8 (Persistence of deadlocks).

  == Fragen
  - Sollen wir paths noch zeigen?
  - Locked Definition hinzufügen?
  - Slide für "how to read LTS-semantics?"

]
#show: simple-theme.with(aspect-ratio: "16-9")

= Correct Black-Box Monitors for Distributed Deadlock Detection: Formalisation and Implementation

== Dissecting the Title
- We are given a network setting with communicating RPC Services
- *RPC*: Remote Procedure Call (Query, Response, Cast)
- *Deadlock*: Cyclic waiting for resources in such a network
- *Distributed*: No central authority
- *Blackbox*: No introspection of services, only communication behaviour
- *Monitors*: Wrappers around service that observe communication

== Contributions
1. Establish criteria for correctness of deadlock detection
2. A formal model for RPC services and communication
3. A formal method to install distributed, black-box, outline monitors
4. A Monitoring algorithm that detects deadlock in a sound and complete way and proves its soundness
5. Implementation of DDMon (for Erlang/OTP)


== Agenda
1. Formalising processes & services
2. Formalising networks
3. Installing monitors
4. A novel deadlock detection algorithm
5. Proof of Soundness & Completeness


// == Wanted Properties
// 1. *Distributed*: No centralized component
// 2. *Blackbox and Outline*: Detect deadlocks by just observing the incoming and outgoing messages of the service they monitor
// 3. *Transparent*: Don't alter the execution
// 4. *Precise*: Detect Deadlock iff it existst

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



== Formalism: LTS Semantics of abstract SRPC Process G
- We define the possible states of an abstract Process G. The LTS semantics are defined in @sem-process using the transitions labels γ.

#v(1cm)
$
  G & := "Ready" | "Working"(n_c^⊥) | "Locked"(n_c^⊥, n_s) \
  γ & := ?n(t) | !n(t) | τ
$

#figure(
  caption: "LTS semantics of the abstract SRPC process G.",
  image("./assets/Fig1.png"),
) <sem-process>

// add the funny circly image?


== Formalism: LTS Semantics of Services
- We extend a process P with queues and search operations to form a service S. The LTS semantics in @lts-service are using the transition labels in β. δ is a transition label for queues.
$
  δ & := ![n(t)] \
  β & := ?n(t) | !n(t) | τ(?n(t)) | τ(!n(t)) | τ(τ)
$

#figure(
  caption: "LTS semantics of services.",
  image("./assets/Fig4.png"),
) <lts-service>

= Networks
== Formalism: Network
$
  α := τ(γ \@ n) | n₀ –(t)→ n₁
$

#figure(
  caption: "LTS semantics of a network.",
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
- Monitor algorithm function: $hat(𝓐): hat(𝓜) × hat(𝔪) -> hat(𝓜) × hat(𝔮)$

== LTS Semantics of Monitored Networks
#figure(
  caption: "LTS semantics of monitored networks & visualization of communication.",
  image("./assets/Fig9_10.png"),
)


// == Formalism: Monitored Network action
// - The lts-semantics given in @lts-monitor-nets is using the transition labels $hat(α)$
// $
//   hat(α) := α | hat(τ)(γ \@ n) | n₀ -(hat(p))-> n₁
// $

// #figure(
//   caption: "LTS semantics of monitored networks",
//   image("./assets/Fig11.png"),
// ) <lts-monitor-nets>


= Instrumentation
- We now discuss the process of transforming a network into a monitored network in which communication is observed by monitors
- Monitor instrumentation: $𝓜 : 𝓝 -> hat(𝓝)$
- Deinstrumentation: $𝓜^(-1): hat(𝓝) → 𝓝$
- This transformation is _transparent_ (Theorem 4.11)

#let rs = text(fill: red)[R]

$
  "(1)" & N(n) = #rs "implies" (𝓜(N))(n) = ⟨hat(q), hat(M), #rs⟩ \
  "(2)" & (𝓜(N))(n) = ⟨hat(q), hat(M), #rs⟩ "implies" N(n) = #rs
$

// == Formalism: Deadlocks Set
// - Todo: Deadlock of single node
// - Todo: Deadlock set


= Deadlock Detection using Probes
- We use an edge-chasing inspired technique and probes
- And send probes as soon as we appear to be locked
- Monitor states $hat(M)$ is a record with the fields: { probe | waiting | alarm }

#figure(
  caption: "Implementation of 𝓐.",
  image("./assets/Fig12.png", width: 50%),
) <alg>


#figure(
  caption: "Deadlock detection algorithm example with three nodes.",
  image("./assets/Fig13.png"),
) <example>



// = Correctness Proofs
// - We strive for an algorithm that is both _sound_ and _complete_
// - Preliminaries:
//   - 6.1 Definition: Initial network and instrumentation
//   - 6.2 Definition: _Client_
//   - 6.3 Definition of well-formed SRPC _client & server_
//   - 6.4 Definition of well-formed SRPC _network_
//   - 6.5 Well-formedness is an invariant
// - Outline of the completeness-proof:
//   - We try to prove that if there is a lock, we see it in the network
//   - 6.7 Complete lock knowledge p.18
//   - 6.8 Alarm condition p.18
//   - 6.9 Alarm condition leads to alarm p.18
//   - 6.10 _Complete_ lock knowledge leads to invariant p.19

// == Soundnessproof
// - Outline of the soundness proof:
//   - 6.11 Sound lock knowledge
//   - 6.12 Sound lock knowlegdge is an invariant

// #figure(
//   caption: "Theorem 6.13 (Deadlock Detection Preciseness)",
//   image("./assets/t613.png"),
// )


= Evaluation
- Overhead is negligible
#figure(
  image("./assets/comp.png", width: 50%),
)

= Thank you for listening!
