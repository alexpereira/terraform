variable "server_port" {
    description = "Port number the service will use for HTTP requests"
    default= 8080
}

variable "load_balancer_port" {
    description = "Port number the load balancer will use to route HTTP requests"
    default= 80
}
