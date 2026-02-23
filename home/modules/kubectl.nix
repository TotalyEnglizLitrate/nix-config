{pkgs, ...} : {
  home.packages = with pkgs; [
    kubectl
    kubectl-doctor
    kubectl-graph
    kubectl-images
    kubectl-example
    kubectl-explore
    kubectl-tree
    kubectl-node-shell
    kubectl-view-secret
    kubecolor
  ];
}
