output "job_definition_arn" {
  value = aws_batch_job_definition.batch.arn
}

output "job_definition_name" {
  value = aws_batch_job_definition.batch.name
}
