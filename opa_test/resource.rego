package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

deny["Only AWS instances allowed!"] {
    r = tfplan.resource_changes[_]
    r.change.actions[_] == "create"
    not tfplan.resource_changes.type == "aws_instance"
}
