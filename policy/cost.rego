package terraform 


import input.tfplan as tfplan
import input.tfrun as tfrun

deny[reason] {
    cost_delta = tfrun.cost_estimate.delta_monthly_cost
    cost_delta > 20
    reason := sprintf("Plan is too expensive: $%.2f, while up to $30 is allowed", [cost_delta])
}
