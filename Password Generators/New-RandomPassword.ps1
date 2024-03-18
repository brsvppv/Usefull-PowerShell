Function Get-RandomPassword($capital, $letters, $numbers, $special) {

    function RandomAssembly($length, $startAscii, $endAscii) {
        $randomChars = 1..$length | ForEach-Object { Get-Random -Minimum $startAscii -Maximum $endAscii }
        return -join [char[]]$randomChars
    }

    function Invoke-ShuffleRoulette([string]$InputString) {     
        $charArray = $inputString.ToCharArray()   
        $stringArray = $charArray | Get-Random -Count $charArray.Length     
        $resultString = -Join ($stringArray)
        return $resultString
    }

    $password = RandomAssembly -length $capital -startAscii 65 -endAscii 90  # ASCII values for uppercase letters
    $password += RandomAssembly -length $letters -startAscii 97 -endAscii 122  # ASCII values for lowercase letters
    $password += RandomAssembly -length $numbers -startAscii 48 -endAscii 57    # ASCII values for numbers
    $password += RandomAssembly -length $special -startAscii 33 -endAscii 47  # ASCII values for some special characters

    return Invoke-ShuffleRoulette $Password
}

# Example usage with dynamic lengths
Get-RandomPassword -capital 3 -letters 5 -Numbers 5 -special 3
