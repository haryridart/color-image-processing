% 8. Color Image Processing 
% Oleh Kelompok 24, 
% Hanif Imam - 17060434273
% Hary Teguh Gurun Gala Ridart - 1706042882
% Muhammad Koku - 1706043203
getd = @(p)path(p,path); % scilab users must *not* execute this
getd('toolbox_signal/');
getd('toolbox_general/');

% RGB Color Space

% ukuran gambar N = nxn
n = 256;
N = n*n;

% membuka gambar f
name = 'hibiscus';
f = rescale( load_image(name,n) );
% ================================3A====================================
% Fungsi cat() merupakan fungsi matlab yang digunakan untuk men-concatenate
% atau menyatukan/menghubungkan lebih dari satu array. dalam contoh fungsi
% cat untuk array R, fungsi cat menghubungkan array f(:,:,1), zeros(n), dan
% zeros(n) secara berurutan dimulai dari array f(:,:,1) sebagai array
% paling kiri lalu diikutin dengan 2 array zeros seukuran n x n pada dimensi 
% bernilai 3 yaitu pada parameter pertama

% Menampilkan gambar f dalam komponen warna pembentuknya RGB
R = cat(3, f(:,:,1), zeros(n), zeros(n));
G = cat(3, zeros(n), f(:,:,2), zeros(n));
B = cat(3, zeros(n), zeros(n), f(:,:,3));
figure (1) %clf;
imageplot({f R G B}, ...
        { 'f' 'R (Red)' 'G (green)' 'B (blue)'}, 2, 2);
    
% CMY Color Space    
% Mencari Luminance Channel
% L = (R+G+B)/3

figure (2) %clf;
imageplot({f mean(f,3)}, {'f' 'L'});

% Menampilkan channel C, f, Y.
f1 = cat(3, f(:,:,1),     f(:,:,2)*0+1, f(:,:,3)*0+1);
f2 = cat(3, f(:,:,1)*0+1, f(:,:,2)    , f(:,:,3)*0+1);
f3 = cat(3, f(:,:,1)*0+1, f(:,:,2)*0+1, f(:,:,3));
figure (3) %clf;
imageplot({f f1 f2 f3}, ...
        { 'f' 'C' 'f' 'Y'}, 2, 2);
    
% YUV Color Space
% Melakukan transformasi untuk mendapatkan linear scale color
T = [.299 .587 .114; ...
    -.14713 -.28886 .436; ...
    .615 -.51499 -.10001]';

% ================================3B====================================
% simbol @ pada matlab biasa digunakan untuk membuat suatu function handle
% yang merupakan suatu tipe data yang menyimpan suatu asosiasi terhadap suatu
% function. Pada contoh tugas ini untuk fungsi yang disimpan pada applymat, function handle
% digunakan agar anonymous function yang dibuat pada baris tersebut dapat
% digunakan dengan lebih mudah. applymat itu sendiri berguna untuk mengubah
% bentuk dari matrix input.

% RGB to YUV conversion dengan matrix
applymat = @(f,T)reshape( reshape(f, [n*n 3])*T, [n n 3] );
rgb2yuv  = @(f)applymat(f,T);

% menampilkan YUV color channel
U = rgb2yuv(f);
figure (4) %clf;
imageplot(U(:,:,1), 'Y', 1,3,1);
imageplot(U(:,:,2), 'U', 1,3,2);
imageplot(U(:,:,3), 'V', 1,3,3);

% memofifikasi YUV dengan menurunkan chrominance gambar, representasi baru
% dinotasikan dalam U1
U1 = U;
U1(:,:,2:3) = U1(:,:,2:3)/2;

% exo1;
% ================================3C====================================
% Exercise 1 menurunkan nilai Chrominance dari gambar asli. hasil dari
% transformasi tersebut menyebabkan gambar termodifikasi menjadi terkesan lebih
% gelap dibandingkan gambar aslinya karena kepekatan dari informasi gambar aslinya telah diturunkan.
% Exercise 1 membatasi warna yang digunakan dalam gambar menjadi 1/2 total warna asli sehingga warna cerah
% pada gambar asli digantikan oleh warna yang lebih gelap (warna yang
% dihasilkan tidak sepekat gambar asli)
rgb2yuv = @(f)applymat(f,T^(-1));
f1 = rgb2yuv(U1);
figure (5) %clf;
imageplot(f, 'Image', 1,2,1);
imageplot(clamp(f1), 'Modified', 1,2,2);

% HSV Color Space 

% menghitung koordinat luminance, orthogonal terhadap [1,1,1]
Value = @(f)sum(f, 3) / sqrt(3);

% menghitung proyeksi pada bidang orthogonal [1,1,1]
A = @(f)( f(:,:,2)-f(:,:,3) )/sqrt(2);
B = @(f)( 2*f(:,:,1) - f(:,:,2) - f(:,:,3) )/sqrt(6);

% mendapatkan komponen (V,A,B) dengan melakukan transformasi RGB terhadap orthogonal matrix T
T = [   1/sqrt(3) 1/sqrt(3) 1/sqrt(3); ...
        0 1/sqrt(2) -1/sqrt(2); ...
        2/sqrt(6) -1/sqrt(6) -1/sqrt(6)];

% function handles untuk Saturation/Hue    
Saturation = @(f)sqrt( A(f).^2 + B(f).^2 );
Hue = @(f)atan2(B(f),A(f));

% ================================3E====================================
% fungsi atan2() pada matlab adalah untuk mengembalikan four-quadrant
% inverse tangent (tan^(-1)) dari input pertama dan input kedua yang
% nilainya harus berupa nilai riil. dalam variabel Hue, fungsi atan2()
% digunakan untuk mencari four-quadrant inverse tangent dari fungsi B(f)
% dan A(f).

% function handles shortcut untuk HSV color transformation
rgb2hsv1 = @(f)cat(3, Hue(f), Saturation(f), Value(f));

g = rgb2hsv1(f);

figure (6) %clf;
imageplot({g(:,:,1) g(:,:,2) g(:,:,3)}, {'H' 'S' 'V'}, 1,3);

% exo2;

% ================================3F====================================
% Exercise 2 bertujuan mengbah Hue dari gambar input dengan cara
% merotasikan komponen Hue sebanyak theta (H = H + tetha). pada gambar hasil Exercise 2,
% dapat dilihat bahwa semakin besar nilai theta semakin berubah warna
% gambar asli yang tadinya merah menjadi ungu atau nila hingga biru seperti pada 
% tetha warna yang telah didefinisikan pada Hue dari warna merah hingga scarlet red (0 - 360 derajat).
a = @(g)g(:,:,2) .* cos(g(:,:,1));
b = @(g)g(:,:,2) .* sin(g(:,:,1));
% This ugly code is for Scilab compatibility
c = @(g)cat(3, g(:,:,3), a(g), b(g));
hsv12rgb = @(g)applymat(c(g),T);
figure (7) %clf;
theta = linspace(0,pi/2,6);
for i=1:length(theta)
    g1 = g;  g1(:,:,1) = g1(:,:,1) + theta(i); 
    imageplot(clamp(hsv12rgb(g1)), ['\theta=' num2str(theta(i))], 2,3,i);
end