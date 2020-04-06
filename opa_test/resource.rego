package terraform 

import input.tfplan as tfplan
import input.tfrun as tfrun

allowed_resource = "aws_instance"

deny["Only AWS instances allowed!"] {
    r = tfplan.resource_changes[_]
    r.type != allowed_resource
}
