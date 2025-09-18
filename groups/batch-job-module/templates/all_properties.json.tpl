{
%{ if containerProperties != null }
  "containerProperties": ${jsonencode(containerProperties)}%{ if nodeProperties != null || eksProperties != null },%{ endif }
%{ endif }
%{ if nodeProperties != null }
  "nodeProperties": ${jsonencode(nodeProperties)}%{ if eksProperties != null },%{ endif }
%{ endif }
%{ if eksProperties != null }
  "eksProperties": ${jsonencode(eksProperties)}
%{ endif }
}
