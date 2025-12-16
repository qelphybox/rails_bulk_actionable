import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import RailsNestedForm from "@stimulus-components/rails-nested-form"

application.register("nested-form", RailsNestedForm)
eagerLoadControllersFrom("controllers", application)
