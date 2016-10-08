#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// color values are between 0 and 1
typedef struct color_st {
    double r;
    double g;
    double b;
} color;

// https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
double linear_rgb(double val) {
    if (val <= 0.03928) {
        return val / 12.92;
    } else {
        return pow((val + 0.055)/1.055, 2.4);
    }
}

double relative_luminance(const color *val) {
    return 0.2126 * linear_rgb(val->r) + 0.7152 * linear_rgb(val->g) + 0.0722 * linear_rgb(val->b);
}

// https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html#contrast-ratiodef
double color_contrast(const color *a, const color *b) {
    double a_l = relative_luminance(a);
    double b_l = relative_luminance(b);
    if (a_l > b_l) {
        return (a_l + 0.05) / (b_l + 0.05);
    } else {
        return (b_l + 0.05) / (a_l + 0.05);
    }
}

int main(int argc, char **argv) {
    if (argc <= 1) {
        fprintf(stderr, "Usage: %s <#color-values>\n", argv[0]);
        return 1;
    }
    int num_values = atoi(argv[1]);
    fprintf(stderr, "Running with %d values\n", num_values);
    color base = {1,1,1};
    color contrast = {0,0,0};
    double inc = 1.0 / (num_values - 1);
    for (contrast.r = 0; contrast.r <= 1.0; contrast.r += inc) {
        printf("%f, ", contrast.r);
        for (contrast.g = 0; contrast.g <= 1.0; contrast.g += inc) {
            for (contrast.b = 0; contrast.b <= 1.0; contrast.b += inc) {
                printf("%f, %f, %f, %f\n", contrast.r, contrast.g, contrast.b, color_contrast(&base, &contrast));
            }
        }
    }
    return 0;
}