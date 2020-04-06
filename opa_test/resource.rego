package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

deny[reason] {
    r = tfplan.resource_changes[_]
    r.change.actions[_] == "create"
    not tfplan.resource_changes.type == "aws_instance"
    reason := sprintf("Only AWS instances are allowed")
}
