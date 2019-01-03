{config, pkgs, ...}: {

  users.users.jenkins = {
    isNormalUser = true;
    hashedPassword="$6$cwimMCFsbe0p$/7dSxYC4E15oaAFXNWq98BP9WZCAFjJq9T9Lg8ttysUjMC6gqnlhJ7xaupVERM.P.Cf39qvkSOUAzSuUUpJ65.";
  };

  services.jenkins.enable = true;
  services.jenkins.extraGroups = [ "docker" ];
  services.jenkins.packages = with pkgs; [ stdenv bash nix git jdk docker config.programs.ssh.package ];

# Jenkins.instance.pluginManager.plugins.forEach {println(it.getShortName()) }
# https://hackage.haskell.org/package/jenkinsPlugins2nix
#services.jenkins.plugins = [
#  "pipeline-input-step"
#  "workflow-job"
#  "scm-api"
#  "ace-editor"
#  "display-url-api"
#  "pipeline-model-api"
#  "pipeline-model-definition"
#  "pipeline-model-extensions"
#  "ldap"
#  "pipeline-rest-api"
#  "antisamy-markup-formatter"
#  "ws-cleanup"
#  "workflow-basic-steps"
#  "workflow-cps"
#  "pipeline-stage-tags-metadata"
#  "trilead-api"
#  "workflow-support"
#  "workflow-api"
#  "structs"
#  "ssh-credentials"
#  "pipeline-stage-view"
#  "lockable-resources"
#  "matrix-auth"
#  "script-security"
#  "jdk-tool"
#  "git-server"
#  "github-api"
#  "pipeline-build-step"
#  "command-launcher"
#  "branch-api"
#  "mailer"
#  "jackson2-api"
#  "pipeline-github-lib"
#  "jquery-detached"
#  "momentjs"
#  "token-macro"
#  "pipeline-milestone-step"
#  "bouncycastle-api"
#  "pipeline-model-declarative-agent"
#  "durable-task"
#  "github-branch-source"
#  "matrix-project"
#  "resource-disposer"
#  "workflow-aggregator"
#  "workflow-cps-global-lib"
#  "jsch"
#  "authentication-tokens"
#  "pam-auth"
#  "apache-httpcomponents-client-4-api"
#  "credentials"
#  "pipeline-stage-step"
#  "handlebars"
#  "docker-commons"
#  "github"
#  "pipeline-graph-analysis"
#  "ssh-slaves"
#  "credentials-binding"
#  "workflow-step-api"
#  "docker-workflow"
#  "workflow-scm-step"
#  "workflow-multibranch"
#  "junit"
#  "git-client"
#  "plain-credentials"
#  "git"
#  "cloudbees-folder"
#  "workflow-durable-task-step"
#  ];
}