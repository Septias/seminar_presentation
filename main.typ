#import "@preview/touying:0.7.4": *
#import themes.simple: *

== Aufbau
1. Motivation
2. Formalisierung erarbeiten
3. Soundness & Completeness Proofs (Sketch?)
4. Deadlock Algorithm


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

== Disecting The Title
- We are given a network setting with communicating RPC Services
- *RPC*: Remote Procedure Call (Query, Response, Cast)
- *Deadlock*: Cyclic waiting for resources in such a network
- *Distributed*: No central authority (due to performance)
- *Blackbox*: No introspection of services, only communication behaviour
- *Monitors*: Wrappers around service that observe communication

== Contributions
- Formal model for RPC services
- Formalised method for distributed, black-box, outline instrumentation
- Monitoring algorithm that detects deadlock in a sound and complete way
- Implementation of DDMon (for Erlang/OTP)


== Agenda
1. Formalising Processes & Services
2. Formalising Networks
3. Installing Monitors
4. Proof for Deadlock-detection
5. Deadlock Detection Algorithm
6. Proof of Soundness & Completeness


== Wanted Properties
1. *Distributed*: No centralized component
2. *Blackbox and outline*: Detect deadlocks by just observing the incoming and outgoing messages of the service they monitor
3. *Transparent*: Don't alter the execution
4. *Precise*: Detect Deadlock iff it existst


// == A Network – formally
// - A network $N$ with Transitions: $N →^α N'$
// - Or for multiple steps: $N →^σ N'$ which we call a _path_
// - A _monitored_ network: $hat(N)$
// - Instrumentation: $ℳ$ and  De-instrumentation: $ℳ^(-1)$
// - Messages in an instrumented network: $hat(N) →^hat(σ) hat(N')$
// - The instrumented network may have more messages!


= Nodes
== Formalism: Services
- The model is reduced to _Single-threaded Remote Procedure Calls_ (SRPC)
$
  "Communication tag" t & := Q | R | C \
               "Name" n & := n₀ | n₁ | … \
           "Client" n^⊥ & := n | ⊥ \
            "Process" P & := … \
              "Queue" q & := ε | n(t) | q ⧺ q \
            "Service" S & := ⟨q^i | P | q^o⟩ \
$
- The Behaviour of P must be compatible with an *abstract SRPC Process G*

- TODO: underline lines?

== Formalism: LTS Semantic of abstract SRPC Process G
> Simulate a single Process P
$
  G & := "Ready" | "Working"(n_c^⊥) | "Locked"(n_c^⊥, n_s) \
  γ & := ?n(t) | !n(t) | τ
$

#figure(
  caption: "LTS semantics of the abstract SRPC process G",
  image("./assets/Fig1.png"),
)

// add the funny circly image?


== Formalism: LTS Semantic of Services
> Extend a process with queues (and search operations)
$
  δ & := ![n(t)] \
  β & := ?n(t) | !n(t) | τ(?n(t)) | τ(!n(t)) | τ(τ)
$

#figure(
  caption: "LTS semantics of services",
  image("./assets/Fig4.png"),
)

= Networks
== Formalism: Network
$
  α := τ(γ \@ n) | n₀ –(t)→ n₁
$

#figure(
  caption: "LTS semantics of services",
  image("./assets/Fig5.png"),
)

== Formalism: Deadlocks Set
- Todo: Deadlock of single node
- Todo: Deadlock set


= Monitors
== Formalism: Monitors
$
  hat(m) & := ?n(t) | !n(t) | ?n(hat(p)) | !n(hat(p)) \
  hat(q) & := ε | hat(m) | hat(q) ++ hat(q) \
  hat(S) & := ⟨hat(q) | P | S⟩ \
$

Monitored service action:
$
  hat(β) := β | ?n(hat(p)) | !n(hat(p)) | hat(τ)(?n(t)) | hat(τ)(!n(t)) | hat(τ)(?n(hat(p)))
$
- $hat(p)$ is a probe
- A monitor $hat(M)$
- A monitored Service: ⟨hat(q) | hat(M) | S⟩
// τ being the internal actions
Monitor algorithm function: hat(𝓐): $(𝓜) x hat(𝔪) -> hat(𝓜) × hat(𝔮)$
// - This function is total


== Formalism: Monitored Network action
$
  hat(α) := α | hat(τ)(γ \@ n) | n₀ -(hat(p))-> n₁
$
monitored path: $hat(σ)$
#figure(
  caption: "LTS semantics of monitored networks",
  image("./assets/Fig11.png"),
)


= Instrumentation
- Monitor instrumentation: $𝓜 : 𝓝 -> hat(𝓝)$
- Deinstrumentation: 𝓜^(-1)
- Monitor stripping operation: $ hat(S)↓: ⟨hat(q) | hat(M) | ⟨q^i | P | q^o⟩⟩ = \ ⟨q^i ++ "filter"^i(hat(q)) | P | q^o ++ "filter"^o(hat(q)) ++ q^o⟩ $
Stripping of monitor path: hat(σ)↓: …


== Theorem 4.8 (Black-box instrumentation transparency — completeness).

= The Algorithm
- Monitor states $hat(M)$ is a record with the fields "probe" | "waiting" | "alarm"
- Implementation of $hat(𝓐)$


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
