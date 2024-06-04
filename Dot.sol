// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

// ::::::::::::::::         :::::::::::::::::::::    :::::::::::::::::::::                    
// ::::::::::::::::         :::::::::::::::::::::    :::::::::::::::::::::                    
// :::::::::::::::::::::    :::::::::::::::::::::    :::::::::::::::::::::                    
// :::::::::::    ::::::    :::::::::::    ::::::    ::::::::::::::::                         
// :::::::::::    ::::::    :::::::::::    ::::::    ::::::::::::::::                         
// :::::::::::    ::::::    :::::::::::    ::::::     :::::::::::::::         ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::         :::::::::::         ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::         :::::::::::         ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::         :::::::::::         ::::::::::::::::
// :::::::::::    ::::::    :::::::::::    ::::::         :::::::::::         ::::::::::::::::
// :::::::::::::::::::::    :::::::::::::::::::::         :::::::::::         ::::::::::::::::
// ::::::::::::::::         :::::::::::::::::::::         :::::::::::         ::::::::::::::::
// ::::::::::::::::         :::::::::::::::::::::         :::::::::::         ::::::::::::::::

contract Dot is ERC721URIStorage, Ownable, ReentrancyGuard {
    string private _decoderCode = "data:text/html;base64,PCFET0NUWVBFIGh0bWw+PHRpdGxlPkRvdCBEZWNvZGVyPC90aXRsZT48bWV0YSBuYW1lPSJ2aWV3cG9ydCIgY29udGVudD0id2lkdGg9ZGV2aWNlLXdpZHRoLGluaXRpYWwtc2NhbGU9MSI+PGJvZHkgc3R5bGU9ImZvbnQtZmFtaWx5OnNhbnMtc2VyaWY7cGFkZGluZzowIDEwcHgiPjxpbWcgc3JjPSJkYXRhOmltYWdlL3BuZztiYXNlNjQsaVZCT1J3MEtHZ29BQUFBTlNVaEVVZ0FBQUY0QUFBQmVCQU1BQUFCWS9MNWRBQUFES1dsVVdIUllUVXc2WTI5dExtRmtiMkpsTG5odGNBQUFBQUFBUEQ5NGNHRmphMlYwSUdKbFoybHVQU0x2dTc4aUlHbGtQU0pYTlUwd1RYQkRaV2hwU0hweVpWTjZUbFJqZW10ak9XUWlQejRnUEhnNmVHMXdiV1YwWVNCNGJXeHVjenA0UFNKaFpHOWlaVHB1Y3pwdFpYUmhMeUlnZURwNGJYQjBhejBpUVdSdlltVWdXRTFRSUVOdmNtVWdPUzR3TFdNd01ERWdOemt1WXpBeU1EUmlNbVJsWml3Z01qQXlNeTh3TWk4d01pMHhNam94TkRveU5DQWdJQ0FnSUNBZ0lqNGdQSEprWmpwU1JFWWdlRzFzYm5NNmNtUm1QU0pvZEhSd09pOHZkM2QzTG5jekxtOXlaeTh4T1RrNUx6QXlMekl5TFhKa1ppMXplVzUwWVhndGJuTWpJajRnUEhKa1pqcEVaWE5qY21sd2RHbHZiaUJ5WkdZNllXSnZkWFE5SWlJZ2VHMXNibk02ZUcxd1BTSm9kSFJ3T2k4dmJuTXVZV1J2WW1VdVkyOXRMM2hoY0M4eExqQXZJaUI0Yld4dWN6cDRiWEJOVFQwaWFIUjBjRG92TDI1ekxtRmtiMkpsTG1OdmJTOTRZWEF2TVM0d0wyMXRMeUlnZUcxc2JuTTZjM1JTWldZOUltaDBkSEE2THk5dWN5NWhaRzlpWlM1amIyMHZlR0Z3THpFdU1DOXpWSGx3WlM5U1pYTnZkWEpqWlZKbFppTWlJSGh0Y0RwRGNtVmhkRzl5Vkc5dmJEMGlRV1J2WW1VZ1VHaHZkRzl6YUc5d0lESTBMalFnS0UxaFkybHVkRzl6YUNraUlIaHRjRTFOT2tsdWMzUmhibU5sU1VROUluaHRjQzVwYVdRNk5rRXdOVFF5UlVSQk9FUkZNVEZGUlRneU9EbEZNemt3TmtReE0wSTRORVVpSUhodGNFMU5Pa1J2WTNWdFpXNTBTVVE5SW5odGNDNWthV1E2TmtFd05UUXlSVVZCT0VSRk1URkZSVGd5T0RsRk16a3dOa1F4TTBJNE5FVWlQaUE4ZUcxd1RVMDZSR1Z5YVhabFpFWnliMjBnYzNSU1pXWTZhVzV6ZEdGdVkyVkpSRDBpZUcxd0xtbHBaRG8yUVRBMU5ESkZRa0U0UkVVeE1VVkZPREk0T1VVek9UQTJSREV6UWpnMFJTSWdjM1JTWldZNlpHOWpkVzFsYm5SSlJEMGllRzF3TG1ScFpEbzJRVEExTkRKRlEwRTRSRVV4TVVWRk9ESTRPVVV6T1RBMlJERXpRamcwUlNJdlBpQThMM0prWmpwRVpYTmpjbWx3ZEdsdmJqNGdQQzl5WkdZNlVrUkdQaUE4TDNnNmVHMXdiV1YwWVQ0Z1BEOTRjR0ZqYTJWMElHVnVaRDBpY2lJL1BtUThraElBQUFBWmRFVllkRk52Wm5SM1lYSmxBRUZrYjJKbElFbHRZV2RsVW1WaFpIbHh5V1U4QUFBQUcxQk1WRVgvLy84SkNBUDl6RmZtNDk1VXJ1L2VLa0tyajlmMGtRUjVzMXBqay83VEFBQUFsMGxFUVZSWXcrMld2UTJEUUJTREgzOFM1ZDBHS0JORXlnSVVESkFtSzJRRldrckdKdGdINGlBZ0VLMi95ZzkvRmRKSk5pcyt3TUFEVk1oNUExaTh3UE9YNU11LzR3ZGF3RnoySXgyUEw3QTE4dVdMRXlSK2dyZGY0UDdjOGsvNWJPYmVvWWo4K1AvTEQvNzhTYjc4ZlgvM1BjcS81b3RqTWs1UkhweW9OWExLOGNxQ28vWXRYLzdLdCswc2pmYnFjc2lhZlBtMy9BSHJ0cVNKdUNMWXpBQUFBQUJKUlU1RXJrSmdnZz09IiBoZWlnaHQ9IjUwIiBzdHlsZT0ibWFyZ2luOjA7Ij48ZGl2IHN0eWxlPSJtYXJnaW4tbGVmdDoxMHB4O2xpbmUtaGVpZ2h0OjUwcHg7Zm9udC1zaXplOjIwcHg7Zm9udC13ZWlnaHQ6Ym9sZDtkaXNwbGF5OmlubGluZTt2ZXJ0aWNhbC1hbGlnbjp0b3A7Ij5EZWNvZGVyPC9kaXY+PHA+RXZlcnkgRG90IGNhcmQgdGhhdCdzIGNvbGxlY3RlZCBmcm9tIDxhIGhyZWY9Imh0dHBzOi8vZG90LmZhbiI+ZG90LmZhbjwvYT4gaXMgc3RvcmVkIG9uY2hhaW4sIGZvcmV2ZXIuPC9wPjxvbD48bGk+R28gdG8gdGhlIERvdCBjb250cmFjdCBhbmQgbmF2aWdhdGUgdG8gdGhlIFJlYWQgQ29udHJhY3QgdGFiLjwvbGk+PGxpPkVudGVyIHlvdXIgdG9rZW4gbnVtYmVyIGluIHRoZSAnZW5jb2RlZEltYWdlJyBzZWN0aW9uLjwvbGk+PGxpPlRha2UgdGhlIG91dHB1dCBhbmQgcGFzdGUgaXQgaW50byB0aGUgYm94IGJlbG93LjwvbGk+PC9vbD48ZGl2IHN0eWxlPSJiYWNrZ3JvdW5kOiNlZWU7cGFkZGluZzoxMHB4Ij48aW5wdXQgaWQ9ImlucHV0SGFzaCIgcGxhY2Vob2xkZXI9IkVudGVyIGVuY29kZWQgaW1hZ2Ugc3RyaW5nIiBzdHlsZT0iZm9udC1zaXplOjIwcHg7d2lkdGg6OTUlIj48YnV0dG9uIG9uY2xpY2s9ImRlY29kZSgpIiBzdHlsZT0ibWFyZ2luLXRvcDo1cHg7Zm9udC1zaXplOjIwcHgiPkRlY29kZSBJbWFnZTwvYnV0dG9uPjwvZGl2PjxwIHN0eWxlPSJjb2xvcjojNjY2O2ZvbnQtc2l6ZToxMnB4Ij5TYW1wbGUgZW5jb2Rpbmcgb2YgYSBmcm9nOjxicj5iNyExMTIyLWI3LTIyfjJiNzIyfjJiN340MjJiNzIyYjcyMmI3MjJiNy0yMmI3fjUyMi1iNy0yMn4yYjctMjJiNzIyYjchMjY3ZC1iNy03ZC1iN343N2ItN2QyMjdkfjIyMjdkYjc3YmI3N2JiNy03YjdkfjJiNzdkfjJiNzdkYjctN2JiN34yN2I3ZH44MjItYjd+MjdiN2R+NzIyLWI3fjQ3YjdkfjRiNy0yMjdkLWI3fjM3YjdkfmFiN34zN2R+YWI3fjQ3ZDdiYjc3ZDdiYjctN2QtN2JiN341N2R+MmI3N2QtYjctN2R+MmI3fjQ8L3A+PGRpdiBzdHlsZT0ibWFyZ2luOjEwcHggMCI+PGJ1dHRvbiBvbmNsaWNrPSJkb3dubG9hZFNWRygpIiBpZD0iZG93bmxvYWRCdXR0b24iIHN0eWxlPSJtYXJnaW4tYm90dG9tOjEwcHg7ZGlzcGxheTpub25lIj5Eb3dubG9hZCBTVkc8L2J1dHRvbj48ZGl2IGlkPSJzdmdPdXRwdXQiPjwvZGl2PjwvZGl2PjxzY3JpcHQ+Y29uc3QgY29sb3JzPVsiI2Y4ZmFmYyIsIiNmMWY1ZjkiLCIjZTJlOGYwIiwiI2NiZDVlMSIsIiM5NGEzYjgiLCIjNjQ3NDhiIiwiIzQ3NTU2OSIsIiMzMzQxNTUiLCIjMWUyOTNiIiwiIzBmMTcyYSIsIiMwMjA2MTciLCIjZjlmYWZiIiwiI2YzZjRmNiIsIiNlNWU3ZWIiLCIjZDFkNWRiIiwiIzljYTNhZiIsIiM2YjcyODAiLCIjNGI1NTYzIiwiIzM3NDE1MSIsIiMxZjI5MzciLCIjMTExODI3IiwiIzAzMDcxMiIsIiNmYWZhZmEiLCIjZjRmNGY1IiwiI2U0ZTRlNyIsIiNkNGQ0ZDgiLCIjYTFhMWFhIiwiIzcxNzE3YSIsIiM1MjUyNWIiLCIjM2YzZjQ2IiwiIzI3MjcyYSIsIiMxODE4MWIiLCIjMDkwOTBiIiwiI2ZhZmFmYSIsIiNmNWY1ZjUiLCIjZTVlNWU1IiwiI2Q0ZDRkNCIsIiNhM2EzYTMiLCIjNzM3MzczIiwiIzUyNTI1MiIsIiM0MDQwNDAiLCIjMjYyNjI2IiwiIzE3MTcxNyIsIiMwYTBhMGEiLCIjZmFmYWY5IiwiI2Y1ZjVmNCIsIiNlN2U1ZTQiLCIjZDZkM2QxIiwiI2E4YTI5ZSIsIiM3ODcxNmMiLCIjNTc1MzRlIiwiIzQ0NDAzYyIsIiMyOTI1MjQiLCIjMWMxOTE3IiwiIzBjMGEwOSIsIiNmZWYyZjIiLCIjZmVlMmUyIiwiI2ZlY2FjYSIsIiNmY2E1YTUiLCIjZjg3MTcxIiwiI2VmNDQ0NCIsIiNkYzI2MjYiLCIjYjkxYzFjIiwiIzk5MWIxYiIsIiM3ZjFkMWQiLCIjNDUwYTBhIiwiI2ZmZjdlZCIsIiNmZmVkZDUiLCIjZmVkN2FhIiwiI2ZkYmE3NCIsIiNmYjkyM2MiLCIjZjk3MzE2IiwiI2VhNTgwYyIsIiNjMjQxMGMiLCIjOWEzNDEyIiwiIzdjMmQxMiIsIiM0MzE0MDciLCIjZmZmYmViIiwiI2ZlZjNjNyIsIiNmZGU2OGEiLCIjZmNkMzRkIiwiI2ZiYmYyNCIsIiNmNTllMGIiLCIjZDk3NzA2IiwiI2I0NTMwOSIsIiM5MjQwMGUiLCIjNzgzNTBmIiwiIzQ1MWEwMyIsIiNmZWZjZTgiLCIjZmVmOWMzIiwiI2ZlZjA4YSIsIiNmZGUwNDciLCIjZmFjYzE1IiwiI2VhYjMwOCIsIiNjYThhMDQiLCIjYTE2MjA3IiwiIzg1NGQwZSIsIiM3MTNmMTIiLCIjNDIyMDA2IiwiI2Y3ZmVlNyIsIiNlY2ZjY2IiLCIjZDlmOTlkIiwiI2JlZjI2NCIsIiNhM2U2MzUiLCIjODRjYzE2IiwiIzY1YTMwZCIsIiM0ZDdjMGYiLCIjM2Y2MjEyIiwiIzM2NTMxNCIsIiMxYTJlMDUiLCIjZjBmZGY0IiwiI2RjZmNlNyIsIiNiYmY3ZDAiLCIjODZlZmFjIiwiIzRhZGU4MCIsIiMyMmM1NWUiLCIjMTZhMzRhIiwiIzE1ODAzZCIsIiMxNjY1MzQiLCIjMTQ1MzJkIiwiIzA1MmUxNiIsIiNlY2ZkZjUiLCIjZDFmYWU1IiwiI2E3ZjNkMCIsIiM2ZWU3YjciLCIjMzRkMzk5IiwiIzEwYjk4MSIsIiMwNTk2NjkiLCIjMDQ3ODU3IiwiIzA2NWY0NiIsIiMwNjRlM2IiLCIjMDIyYzIyIiwiI2YwZmRmYSIsIiNjY2ZiZjEiLCIjOTlmNmU0IiwiIzVlZWFkNCIsIiMyZGQ0YmYiLCIjMTRiOGE2IiwiIzBkOTQ4OCIsIiMwZjc2NmUiLCIjMTE1ZTU5IiwiIzEzNGU0YSIsIiMwNDJmMmUiLCIjZWNmZWZmIiwiI2NmZmFmZSIsIiNhNWYzZmMiLCIjNjdlOGY5IiwiIzIyZDNlZSIsIiMwNmI2ZDQiLCIjMDg5MWIyIiwiIzBlNzQ5MCIsIiMxNTVlNzUiLCIjMTY0ZTYzIiwiIzA4MzM0NCIsIiNmMGY5ZmYiLCIjZTBmMmZlIiwiI2JhZTZmZCIsIiM3ZGQzZmMiLCIjMzhiZGY4IiwiIzBlYTVlOSIsIiMwMjg0YzciLCIjMDM2OWExIiwiIzA3NTk4NSIsIiMwYzRhNmUiLCIjMDgyZjQ5IiwiI2VmZjZmZiIsIiNkYmVhZmUiLCIjYmZkYmZlIiwiIzkzYzVmZCIsIiM2MGE1ZmEiLCIjM2I4MmY2IiwiIzI1NjNlYiIsIiMxZDRlZDgiLCIjMWU0MGFmIiwiIzFlM2E4YSIsIiMxNzI1NTQiLCIjZWVmMmZmIiwiI2UwZTdmZiIsIiNjN2QyZmUiLCIjYTViNGZjIiwiIzgxOGNmOCIsIiM2MzY2ZjEiLCIjNGY0NmU1IiwiIzQzMzhjYSIsIiMzNzMwYTMiLCIjMzEyZTgxIiwiIzFlMWI0YiIsIiNmNWYzZmYiLCIjZWRlOWZlIiwiI2RkZDZmZSIsIiNjNGI1ZmQiLCIjYTc4YmZhIiwiIzhiNWNmNiIsIiM3YzNhZWQiLCIjNmQyOGQ5IiwiIzViMjFiNiIsIiM0YzFkOTUiLCIjMmUxMDY1IiwiI2ZhZjVmZiIsIiNmM2U4ZmYiLCIjZTlkNWZmIiwiI2Q4YjRmZSIsIiNjMDg0ZmMiLCIjYTg1NWY3IiwiIzkzMzNlYSIsIiM3ZTIyY2UiLCIjNmIyMWE4IiwiIzU4MWM4NyIsIiMzYjA3NjQiLCIjZmRmNGZmIiwiI2ZhZThmZiIsIiNmNWQwZmUiLCIjZjBhYmZjIiwiI2U4NzlmOSIsIiNkOTQ2ZWYiLCIjYzAyNmQzIiwiI2EyMWNhZiIsIiM4NjE5OGYiLCIjNzAxYTc1IiwiIzRhMDQ0ZSIsIiNmZGYyZjgiLCIjZmNlN2YzIiwiI2ZiY2ZlOCIsIiNmOWE4ZDQiLCIjZjQ3MmI2IiwiI2VjNDg5OSIsIiNkYjI3NzciLCIjYmUxODVkIiwiIzlkMTc0ZCIsIiM4MzE4NDMiLCIjNTAwNzI0IiwiI2ZmZjFmMiIsIiNmZmU0ZTYiLCIjZmVjZGQzIiwiI2ZkYTRhZiIsIiNmYjcxODUiLCIjZjQzZjVlIiwiI2UxMWQ0OCIsIiNiZTEyM2MiLCIjOWYxMjM5IiwiIzg4MTMzNyIsIiM0YzA1MTkiLCIjMzlmZjE0IiwiIzdmZmYwMCIsIiNkZmZmMDAiLCIjZTdlZTRmIiwiI2ZmZjAxZiIsIiNmZjVlMDAiLCIjZmYzMTMxIiwiI2ZmNDRjYyIsIiNmZjE0OTMiLCIjZWEwMGZmIiwiI2JjMTNmZSIsIiM4YTJiZTIiLCIjMWY1MWZmIiwiIzBmZjBmYyJdO2Z1bmN0aW9uIGRlY29kZSgpe2NvbnN0IGY9ZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoImlucHV0SGFzaCIpLnZhbHVlO2xldCBlPW51bGwsZD1udWxsLGE9bnVsbCxjPTAsdD0wLGI9IiI7ZnVuY3Rpb24gbihmKXtiKz1gPHJlY3QgeD0iJHt0fSIgeT0iJHtjfSIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0iJHtmfSIgc2hhcGUtcmVuZGVyaW5nPSJjcmlzcEVkZ2VzIiAvPmAsdCsrLHQ+MTUmJih0PTAsYysrKX1mdW5jdGlvbiBvKGYpe2ZvcihsZXQgZD0wO2Q8ZjtkKyspbihlKX1mLnNwbGl0KCIiKS5mb3JFYWNoKChmPT57aWYoZClpZihbIn4iLCIhIl0uaW5jbHVkZXMoZCkpaWYoIn4iPT09ZCl7byhwYXJzZUludChmLDE2KSksZD1hPWU9bnVsbH1lbHNlIGlmKGEpe28ocGFyc2VJbnQoYCR7YX0ke2Z9YCwxNikpLGQ9YT1lPW51bGx9ZWxzZSBhPWY7ZWxzZXtjb25zdCBjPXBhcnNlSW50KGAke2R9JHtmfWAsMTYpO2U9Y29sb3JzW2NdLG4oZSksZD1hPW51bGx9ZWxzZSItIiE9PWY/ZD1mOihuKGUpLGQ9YT1lPW51bGwpfSkpO2NvbnN0IGw9YDxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94PSIwIDAgMTYgMTYiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9ImF1dG8iPiR7Yn08L3N2Zz5gO2RvY3VtZW50LmdldEVsZW1lbnRCeUlkKCJzdmdPdXRwdXQiKS5pbm5lckhUTUw9bCxkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgiZG93bmxvYWRCdXR0b24iKS5zdHlsZS5kaXNwbGF5PSJibG9jayJ9ZnVuY3Rpb24gZG93bmxvYWRTVkcoKXtjb25zdCBmPWRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCJzdmdPdXRwdXQiKS5pbm5lckhUTUw7aWYoIWYpcmV0dXJuIHZvaWQgYWxlcnQoIkRlY29kZSBhbiBpbWFnZSBmaXJzdCEiKTtjb25zdCBlPW5ldyBCbG9iKFtmXSx7dHlwZToiaW1hZ2Uvc3ZnK3htbCJ9KSxkPVVSTC5jcmVhdGVPYmplY3RVUkwoZSksYT1kb2N1bWVudC5jcmVhdGVFbGVtZW50KCJhIik7YS5ocmVmPWQsYS5kb3dubG9hZD0iZGVjb2RlZC5zdmciLGRvY3VtZW50LmJvZHkuYXBwZW5kQ2hpbGQoYSksYS5jbGljaygpLGRvY3VtZW50LmJvZHkucmVtb3ZlQ2hpbGQoYSksVVJMLnJldm9rZU9iamVjdFVSTChkKX1mdW5jdGlvbiBnZXRVUkxQYXJhbWV0ZXIoZil7cmV0dXJuIG5ldyBVUkxTZWFyY2hQYXJhbXMod2luZG93LmxvY2F0aW9uLnNlYXJjaCkuZ2V0KGYpfWZ1bmN0aW9uIGRlY29kZUZyb21VUkwoKXt2YXIgZj1nZXRVUkxQYXJhbWV0ZXIoImRvdCIpO2YmJihkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgiaW5wdXRIYXNoIikudmFsdWU9ZixkZWNvZGUoKSl9d2luZG93Lm9ubG9hZD1kZWNvZGVGcm9tVVJMOzwvc2NyaXB0PjwvYm9keT48L2h0bWw+";
    string private _baseContractURI = "https://nft.dot.fan/ipfs/QmX2F1qhJdpszf4rChiS21kkC6aWZ1vvt2CkcrzYFjMChA";
    uint256 private _reserved = 0;
    uint256 private _creatorFee = 615000000000000; // 0.000615 ETH
    uint256 private _nextTokenId = 0;
    bool private _initialized = false;
    mapping(uint256 => string) _tokenEncodedImage;
    mapping(address => uint256) _sharePerWallet;

    constructor(address initialOwner) Ownable(initialOwner) ERC721("Dot Card", "DOT") {
        require(!_initialized, "Already initialized");
        _initialized = true;
    }

    receive() external payable {}

    function contractURI() public view returns (string memory) {
        return _baseContractURI;
    }

    function setContractURI(
        string memory newContractURI
    ) public onlyOwner() nonReentrant() returns (string memory) {
        _baseContractURI = newContractURI;

        return _baseContractURI;
    }

    function decoderCode() public view returns (string memory) {
        return _decoderCode;
    }

    function setDecoderCode(
        string memory newDecoderCode
    ) public onlyOwner() nonReentrant() returns (string memory) {
        _decoderCode = newDecoderCode;

        return _decoderCode;
    }

    function encodedImage(uint256 tokenId) public view returns (string memory) {
        return _tokenEncodedImage[tokenId];
    }

    function getCreatorFee() public view returns (uint256) {
        return _creatorFee;
    }

    function setCreatorFee(
        uint256 creatorFee
    ) public onlyOwner() nonReentrant() returns (uint256) {
        _creatorFee = creatorFee;

        return _creatorFee;
    }

    function nextToken() public view returns (uint256) {
        return _nextTokenId + 1;
    }

    function reservedForDot() public view returns (uint256) {
        return address(this).balance - _reserved;
    }

    function reservedForCreators() public view returns (uint256) {
        return _reserved;
    }

    function reservedForCreator(
        address creator
    ) public view returns (uint256) {
        return _sharePerWallet[creator];
    }

    function withdraw(
        address payable creator
    ) public onlyOwner() nonReentrant() returns (uint256) {
        uint256 amount = _sharePerWallet[creator];

        require(amount <= address(this).balance, "Insufficient balance");

        _sharePerWallet[creator] = 0;
        _reserved -= amount;

        Address.sendValue(creator, amount);

        return amount;
    }

    function withdrawDotPartial(
        uint256 amount
    ) public onlyOwner() nonReentrant() returns (uint256) {
        require(amount <= address(this).balance - _reserved, "Insufficient balance");

        Address.sendValue(payable(owner()), amount);

        return amount;
    }

    function withdrawDot() public onlyOwner() nonReentrant() returns (uint256) {
        uint256 amount = address(this).balance - _reserved;

        require(amount > 0, "Insufficient balance");

        Address.sendValue(payable(owner()), amount);

        return amount;
    }

    function mintCustomCreatorFee(
        address collector,
        string memory tokenURI,
        string memory encoded,
        address creator,
        uint256 amount
    ) public onlyOwner() nonReentrant() returns (uint256) {
        _nextTokenId++;
        uint256 tokenId = _nextTokenId;
        
        _mint(collector, tokenId);
        _setTokenURI(tokenId, tokenURI);
        
        _tokenEncodedImage[tokenId] = encoded;

        if(_sharePerWallet[creator] > 0) {
            _sharePerWallet[creator] += amount;
        } else {
            _sharePerWallet[creator] = amount;
        }

        _reserved += amount;

        return tokenId;
    }

    function mint(
        address collector,
        string memory tokenURI,
        string memory encoded,
        address creator
    ) public onlyOwner() nonReentrant() returns (uint256) {
        uint256 amount = _creatorFee;
        
        _nextTokenId++;
        uint256 tokenId = _nextTokenId;

        _mint(collector, tokenId);
        _setTokenURI(tokenId, tokenURI);

        _tokenEncodedImage[tokenId] = encoded;

        if(_sharePerWallet[creator] > 0) {
            _sharePerWallet[creator] += amount;
        } else {
            _sharePerWallet[creator] = amount;
        }

        _reserved += amount;

        return tokenId;
    }

    function mintCreator(
        address collector,
        string memory tokenURI,
        string memory encoded
    ) public onlyOwner() nonReentrant() returns (uint256) {
        _nextTokenId++;
        uint256 tokenId = _nextTokenId;
        _mint(collector, tokenId);
        _setTokenURI(tokenId, tokenURI);
        _tokenEncodedImage[tokenId] = encoded;

        return tokenId;
    }

    function setTokenURI(
        uint256 tokenId,
        string memory tokenURI
    ) public onlyOwner() nonReentrant() returns (uint256) {
        _setTokenURI(tokenId, tokenURI);

        return tokenId;
    }

    function setEncodedImage(
        uint256 tokenId,
        string memory encoded
    ) public onlyOwner() nonReentrant() returns (uint256) {
        _tokenEncodedImage[tokenId] = encoded;

        return tokenId;
    }
}