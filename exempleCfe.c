/*----------------------------*/
/* un petit programme exemple
  pour montrer le langage.*/
/*----------------------------*/

 int t[100];
 extern int printd(int d);

 int calcul(int x, int y) {
   return (x*y);
 }

 int main() {
   int i;
   for (i=0; i<100; i=i+1) {
     int j;
     j=i+1;
     t[i]=calcul(i,j);
   }
   printd(t[i-1]);
 }
