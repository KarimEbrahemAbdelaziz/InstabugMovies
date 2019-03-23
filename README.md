# InstabugMovies
InstabugMovies is an iOS application built as interview task at Instabug. Built Using MVP (Model-View-Presenter) and Clean Architecture concepts

### Run Requirements

* Xcode 10
* Swift 4.2

### High Level Layers

#### MVP Concepts (Presentation Logic)
* **`View`** - delegates user interaction events to the `Presenter` and displays data passed by the `Presenter`
* All `UIViewController`, `UIView`, `UITableViewCell` subclasses belong to the `View` layer
* Usually the view is passive / dumb - it shouldn't contain any complex logic and that's why most of the times I don't need write Unit Tests for it
* **`Presenter`** - contains the presentation logic and tells the `View` what to present
* Usually I have one `Presenter` per scene (view controller)
* It doesn't reference the concrete type of the `View`, but rather it references the `View` protocol that is implemented usually by a `UIViewController` subclass
* It should be a plain `Swift` class and not reference any `iOS` framework classes - this makes it easier to reuse it maybe in a `macOS` application
* It should be covered by Unit Tests
* **`Configurator`** - injects the dependency object graph into the scene (view controller)
* Unfortunately DI libraries are not quite mature yet on `iOS` / `Swift`
* Usually it contains very simple logic and I don't need to write Unit Tests for it
* **`Router`** - contains navigation / flow logic from one scene (view controller) to another
* In some communities / blog posts it might be referred to as a `FlowController`
* Writing tests for it is quite difficult because it contains many references to `iOS` framework classes so usually I try to keep it really simple and I don't write Unit Tests for it
* It is usually referenced only by the `Presenter` but due to the `func prepare(for segue: UIStoryboardSegue, sender: Any?)` method I some times need to reference it in the view controller as well
