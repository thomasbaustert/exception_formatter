require "tb_setup_ci/recipes"

set :user, "jenkins"
set :ci_job, "exception_formatter"
set :ci_job_git_branch, "master"
set :repository, "git@git.thomasbaustert.de:repos/exception_formatter.git"

#set :db_config_dir, "test/dummy/config/"

set :ci_run_tests, false
set :ci_run_specs, true
set :ci_run_coverage, false
set :ci_coverage_task, "app:spec:rcov"

role :ci, "ci.thomasbaustert.de"

