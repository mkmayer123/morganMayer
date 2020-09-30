function [reverseString] = gnirtsEsrever(string)

reverseString = reverse(string);
reverseString = lower(reverseString);
idx=regexp([' ' reverseString], '(?<=\s+)\S', 'start')-1;
reverseString(idx)=upper(reverseString(idx));

end