function Measure-StringDistance {
    <#
        .SYNOPSIS
            Compute the distance between two strings using the Damerau-Levenshtein distance formula.
        
        .DESCRIPTION
            Compute the distance between two strings using the Damerau-Levenshtein distance formula.

        .PARAMETER Source
            The source string.

        .PARAMETER Compare
            The comparison string.

        .EXAMPLE
            PS C:\> Measure-StringDistance -Source "Michael" -Compare "Micheal"

            1

            There is one transposition of characters, "a" and "e".

        .EXAMPLE
            PS C:\> Measure-StringDistance -Source "Michael" -Compare "Michal"

            1

            There is one character that is different, "e".

        .NOTES
            Author:
            Michael West
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([int])]
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$Source = "",
        [string]$Compare = ""
    )
    $n = $Source.Length;
    $m = $Compare.Length;
    $d = New-Object 'int[,]' $($n+1),$($m+1)
        
    if ($n -eq 0){
        return $m
    }
    if ($m -eq 0){
        return $n
    }

    for ([int]$i = 0; $i -le $n; $i++){
        $d[$i, 0] = $i
    }
    for ([int]$j = 0; $j -le $m; $j++){
        $d[0, $j] = $j
    }

    for ([int]$i = 1; $i -le $n; $i++){
        for ([int]$j = 1; $j -le $m; $j++){
            if ($Compare[$($j - 1)] -eq $Source[$($i - 1)]){
                $cost = 0
            }
            else{
                $cost = 1
            }

            $d[$i, $j] = [Math]::Min(
                [Math]::Min(
                    $($d[$($i - 1), $j] + 1), # deletion
                    $($d[$i, $($j - 1)] + 1)  # insertion
                ),
                $($d[$($i - 1), $($j - 1)] + $cost)  # substitution
            )

            if ($i -gt 1 -and $j -gt 1 -and $Compare[$($j - 1)] -eq $Source[$($i - 2)] -and $Compare[$($j - 2)] -eq $Source[$($i - 1)]){
                $d[$i, $j] = [Math]::Min(
                    $($d[$i, $j]),
                    $($d[$($i - 2), $($j - 2)] + $cost)  # transposition
                )
            }
        }
    }
        
    return $d[$n, $m]
}
