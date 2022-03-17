
## DONE-Checklist

### 1. Implementation

- [ ] All acceptance criteria of the backlog item have been met
- [ ] Software development [guidelines and code conventions](../coding-guidelines) have been met

### 2. VCS

- [ ] Local branch created
- [ ] Meaningful commit comments
- [ ] Optional: linking to GitHub issues.

### 3. Free of warnings and bugs.

- [ ] The newly implemented code is free of warnings and errors from the compiler or build system (e.g. yocto).
- [ ] Exception: external software components where compiler warnings cannot be removed due to the architecture

### 4. Documentation

- [ ] Code comments (e.g. doxygen).
- [ ] Description of implementation or changes in pull request or backlog issue. 

### 5. Functional test performed.

- [ ] Free, individual (choice of components, interfaces, variables, etc. is the responsibility of the developer).
- [ ] Device runs without errors
- [ ] The features required in the backlog-issue are working or the described errors have been corrected.

### 6. Pull request created and review performed

- [ ] Create pull request
- [ ] Review
  - [ ] Suitable colleagues set as reviewers in the pull request;
  - [ ] Implemented in pair programming;
  - [ ] Readability and maintainability of the source code is ensured
  - [ ] free of duplicates, dead code and technical debt (e.g. fix bugs in an already existing function when it is "touched")
  - [ ] Checklist (**TODO**) has been observed
- [ ] After successful review: Merge into main branch (e.g. ``main``).
- [ ] Deletion of the branch

### 7. Acceptance criteria accepted

- [ ] Fulfillment of acceptance criteria has been confirmed by a colleague (developer, managers, members of the product group).
- [ ] e.g. execution of the functional test (from 5.) by the colleague
